#!/bin/bash

# Copyright 2017
#     Rafael Alves <rafaces@gmail.com>
#     Zhenlei Ji <zhenlei.ji@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

 
# DESCRIPTION
# Easy way to check IBM menu
#
# HOW TO USE
# Commands:
# ~$ ./ibms2.sh

URL_IBM_BASE="http://www.eurest-extranet.de"
URL_IBM_RESTAURANT=$URL_IBM_BASE"/eurest/cms/ibm-duesseldorf/de/restaurant"
CALENDAR_WEEK=`date +%V`

function writeIBM {
	echo " _____ ____  __  __ "
	echo "|_   _|  _ \|  \/  |"
 	echo "  | | | |_) | \  / |"
	echo "  | | |  _ <| |\/| |"
	echo " _| |_| |_) | |  | |"
	echo "|_____|____/|_|  |_|"
	echo "    With love <3.   "
	echo
	echo
}

writeIBM
echo "Parsing IBM website..."
pdf_path=`curl $URL_IBM_RESTAURANT \
	| grep -m 1 "/eurest/export/sites/default.*pdf\".*>.*KW\s*$CALENDAR_WEEK" \
	| sed 's/^.*href="//' \
	| sed 's/" target=".*$//'`

pdf_full_path=$URL_IBM_BASE$pdf_path
pdf_filename=$(basename $pdf_path)

echo
echo "Checking whether $pdf_filename exists..."

if [ ! -e $pdf_filename ]
then
	echo "$pdf_filename missing. Download file..."
	curl -O $pdf_full_path || wget $pdf_full_path
else
	echo "$pdf_filename exists!"
fi

echo
echo "Opening $pdf_filename..."
open $pdf_filename
