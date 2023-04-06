#!/bin/bash
#set -vx		# debug 
set -a			# environment variable autoexport on
LANG=en_US.UTF-8	# locale settings
eval `locale`

####  setup section ########
TEXTSPLIT_SIZE=20000
PARALLEL_COUNT=8
#TXT_TO_WAV="RHVoice-test -p Aleksandr -r 160 -t 80 -v 80 -o -"
#TXT_TO_WAV="RHVoice-test -p Aleksandr -r 150 -t 100 -v 80 -o -"
#TXT_TO_WAV="RHVoice-client -p Anna -r 100 -t 80 -v 130 -o -"
#TXT_TO_WAV="RHVoice-client -s Anna+CLB -r 0 -p -0.3 -v 1"
#TXT_TO_WAV="RHVoice-test -p Anna -r 100 -t 80 -v 130 -o -"
#TXT_TO_WAV="RHVoice-test -p Elena -r 150 -t 100 -v 80 -o -"
## my TTS parameters
VV_TXT_TO_WAV="RHVoice-test -R 360 -p Anna -r 105 -t 80 -v 130 -o -"

## wife TTS parameters
RR_TXT_TO_WAV="RHVoice-test -R 360 -q 200 -p Aleksandr-hq -r 110 -t 100 -v 130 -o -"



WAV_TO_MP3="lame --quiet --id3v2-utf16 --add-id3v2 -f -b 64"

## if directory contain wife name, settings her TTS settings
if echo $PWD|grep -i rena
then
TXT_TO_WAV=$RR_TXT_TO_WAV
else
TXT_TO_WAV=$VV_TXT_TO_WAV
fi

#RUNDIR=`dirname -- "$0"`

RUNDIR=~/bin
export NN MYNAME MYFILE MYDIR RUNDIR


#######################################################################
# split fb2/txt files and convert it to mp3
#######################################################################
function to_fb2(){

#### runtime setting section
MYDIR="`dirname -- "$1"`"
MYFILE="`basename -- "$1"`"

if echo "$MYFILE"|grep -i ".fb2"
then
CAT="xsltproc $RUNDIR/fb2txt.xslt"
MYNAME="`basename -- "$MYFILE" .fb2`"
else
CAT=cat
MYNAME="`basename -- "$MYFILE" .txt`"
fi

echo -- "#### $MYNAME"

cd "$MYDIR"
mkdir -p -- "$MYNAME/txt"
cd -- "$MYNAME"
$CAT ../"$MYFILE"|\
deutf8.sh|\
tr -d "\r"|\
split --additional-suffix=.txt -a 3  -d -C $TEXTSPLIT_SIZE -- -  txt/
cd txt
NN=`ls|wc -l`
set +a

export NN MYNAME MYFILE MYDIR RUNDIR

ls  *.txt | xargs -P $PARALLEL_COUNT -I {} bash -c "to_mp3 \"{}\""
##done

cd ..
rm -rf txt/
ls *.mp3> "$MYNAME.m3u"

}

#######################################################################
# convert one txt file to mp3
#######################################################################
function to_mp3(){
#echo Convert $1 of $NN .....
n=$(basename "$1" .txt)
echo "Convert $MYNAME: $n of $NN ..."
if [ ! -r ../"$n".mp3 ]
then
cat "$1"|$TXT_TO_WAV|$WAV_TO_MP3 --tl "${MYNAME}" --tt "${n}-${MYNAME}" --tn "$n" - ../"$n".mp3
fi
}


export  NN MYNAME MYFILE MYDIR RUNDIR
export -f to_mp3 to_fb2




#######################################################################
# main section
#######################################################################


# find book's and convert it's

if [ .$#. == .0. ]
then
  find . -type f \( -name \*.fb2 -o -name \*.txt \) -exec bash -c "to_fb2 \"{}\"" \;
#  find . -name \*.fb2 -exec bash -c "to_fb2 \"{}\"" \;
else
  to_mp3  "$1"
fi

