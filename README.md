The scripts need RHVoice , xsltproc packages

For install, copy *.sh and xslt file to ~/bin and set 0755 mode to its.

script work steps

1) setup environments variables
TEXTSPLIT_SIZE=20000 ## ~10 min audio
PARALLEL_COUNT=8
TXT_TO_WAV
WAV_TO_MP3
if current directory contains name rena, then settings TTS parameters TXT_TO_WAV for my wife, else  used default settings 
 
2) find fb2 or txt files from current directory

3) make subdirectory by book name

4) make subdirectory bookname/txt

5)  convert fb2 to text if need and split text by TEXTSPLIT_SIZE. Additinaly  cut special chracters and url links from its.  

6)  by list of splitted text files run convert txt to mp3 on PARALLEL_COUNT threads

7) make bookname/bookname.m3u

8) remove temprary directory bookname/txt

9) find next book

