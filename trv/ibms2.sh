#!/bin/bash
# Nome:
#     Zhenlei Ji <zhenlei.ji@gmail.com>
#     Rafael Alves <rafaces@gmail.com>
#
# Easy way to check IBM menu
#
# HOW TO USE
# Commands:
# ~$ ./ibms2.sh
#

URL_IBM_BASE="http://www.eurest-extranet.de"
URL_IBM_RESTAURANT=$URL_IBM_BASE"/eurest/cms/ibm-duesseldorf/de/restaurant"
CALENDAR_WEEK=`date +%V`

echo
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
