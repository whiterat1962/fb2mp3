#!/bin/bash
#/usr/bin/perl -Mopen=locale -Mutf8 -pe 'y/—–«»…“”‘’\*\#\@/\-\-"".""""   /' | sed  -E -e 's#http[s]{0,1}://[[:graph:]~]+#link#gi'
sed  -E -e 's#http[s]{0,1}://[[:graph:]~]+#link#gi' | /usr/bin/perl -Mopen=locale -Mutf8 -pe 'y/—–«»…“”‘’\*\#\@/\-\-"".""""   /'|grep -E -v "^\([0-9]{1,3}\)"
