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

URL_IBM_BASE="http://ibm-duesseldorf.eurest.de"
URL_IBM_RESTAURANT=$URL_IBM_BASE"/restaurant-duesseldorf/microsite/speiseplan"
CALENDAR_WEEK=`date +%V`

function writeIBM {
	echo "███████████  ████████████      ████████      ████████"
	echo "███████████  ███████████████   █████████    █████████"
	echo "   █████        ████   █████     ████████  ████████  "
	echo "   █████        ███████████      ████  ███ ███ ████  "
	echo "   █████        ███████████      ████  ███████ ████  "
	echo "   █████        ████   █████     ████   █████  ████  "
	echo "███████████  ███████████████   ██████    ███   ██████"
	echo "███████████  ████████████      ██████     █    ██████"
	echo "                                        With love <3 "
	echo
	echo
}

writeIBM
echo "Parsing IBM website..."
pdf_path=`curl $URL_IBM_RESTAURANT \
	| grep -m 1 "/assets/ibm-duesseldorf/restaurant-duesseldorf/Microsite/.*pdf\".*>Speiseplan engl.*KW\s*$CALENDAR_WEEK" \
	| sed 's/^.*href="//' \
	| sed 's/" target=".*$//'`

pdf_full_path=$URL_IBM_BASE$pdf_path
pdf_base_name="SpeisenplanIBMKW"
pdf_filename="$pdf_base_name$CALENDAR_WEEK.pdf"
pdf_local_path="./$pdf_filename"

if [ -z "$pdf_path" ]
then
	echo "Something went wrong..."
else
	echo "Checking whether $pdf_filename exists..."

	if [ ! -e $pdf_filename ] || [ ! -s $pdf_filename ]
	then
		echo "$pdf_filename missing. Download file..."
		curl $pdf_full_path -o $pdf_local_path || wget -O $pdf_local_path $pdf_full_path
		echo "Deleting older files"
		ls | grep -E "^$pdf_base_name([0-5]?[0-9]).pdf$" | grep -v "$pdf_filename" | xargs rm
	else
		echo "$pdf_filename exists!"
	fi

	echo

	if [ -s $pdf_filename ]
	then
		echo "Opening $pdf_filename..."
		open $pdf_filename
	else
		echo "Something went wrong..."
	fi
fi