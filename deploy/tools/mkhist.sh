#!/bin/bash

dstart=20191101
dstop=20191130
do_make() {
	# $1, start date
	# $2, stop date
	for ((d=$1;d<=$2;d++));do
			echo ICOS/ICOS_$d.tgz
			echo OS/OS_$d.tar.gz
	done
}

do_2019(){
	bash /g2/tools/mkhist.sh 20190901 20190915 > 2020-04-01_01.lst
	bash /g2/tools/mkhist.sh 20190916 20190930 > 2020-04-02_01.lst
	bash /g2/tools/mkhist.sh 20190801 20190815 > 2020-04-03_01.lst
	bash /g2/tools/mkhist.sh 20190816 20190831 > 2020-04-04_01.lst
	bash /g2/tools/mkhist.sh 20190701 20190715 > 2020-04-05_01.lst
	bash /g2/tools/mkhist.sh 20190716 20190731 > 2020-04-06_01.lst
	
	bash /g2/tools/mkhist.sh 20190601 20190615 > 2020-04-08_01.lst
	bash /g2/tools/mkhist.sh 20190616 20190630 > 2020-04-09_01.lst
	bash /g2/tools/mkhist.sh 20190501 20190515 > 2020-04-10_01.lst
	bash /g2/tools/mkhist.sh 20190516 20190531 > 2020-04-11_01.lst
	bash /g2/tools/mkhist.sh 20190401 20190415 > 2020-04-12_01.lst
	bash /g2/tools/mkhist.sh 20190416 20190430 > 2020-04-13_01.lst
	bash /g2/tools/mkhist.sh 20190301 20190315 > 2020-04-14_01.lst
	bash /g2/tools/mkhist.sh 20190316 20190331 > 2020-04-15_01.lst
	bash /g2/tools/mkhist.sh 20190201 20190215 > 2020-04-16_01.lst
	bash /g2/tools/mkhist.sh 20190216 20190228 > 2020-04-17_01.lst
	bash /g2/tools/mkhist.sh 20190101 20190115 > 2020-04-18_01.lst
	bash /g2/tools/mkhist.sh 20190116 20190131 > 2020-04-19_01.lst
	
	bash /g2/tools/mkhist.sh 20190401 20190415 > 2020-04-19_01.lst
	bash /g2/tools/mkhist.sh 20190416 20190430 > 2020-04-20_01.lst
	
}

do_2018(){
	bash /g2/tools/mkhist.sh 20180101 20180115 > 2020-05-24_01.lst
	bash /g2/tools/mkhist.sh 20180116 20180131 > 2020-05-23_01.lst
	bash /g2/tools/mkhist.sh 20180201 20180215 > 2020-05-22_01.lst
	bash /g2/tools/mkhist.sh 20180216 20180228 > 2020-05-21_01.lst
	bash /g2/tools/mkhist.sh 20180301 20180315 > 2020-05-20_01.lst
	bash /g2/tools/mkhist.sh 20180316 20180331 > 2020-05-19_01.lst
	bash /g2/tools/mkhist.sh 20180401 20180415 > 2020-05-18_01.lst
	bash /g2/tools/mkhist.sh 20180416 20180430 > 2020-05-17_01.lst
	bash /g2/tools/mkhist.sh 20180501 20180515 > 2020-05-16_01.lst
	bash /g2/tools/mkhist.sh 20180516 20180531 > 2020-05-15_01.lst
	bash /g2/tools/mkhist.sh 20180601 20180615 > 2020-05-14_01.lst
	bash /g2/tools/mkhist.sh 20180616 20180630 > 2020-05-13_01.lst
	bash /g2/tools/mkhist.sh 20180701 20180715 > 2020-05-12_01.lst
	bash /g2/tools/mkhist.sh 20180716 20180731 > 2020-05-11_01.lst
	bash /g2/tools/mkhist.sh 20180801 20180815 > 2020-05-10_01.lst
	bash /g2/tools/mkhist.sh 20180816 20180831 > 2020-05-09_01.lst
	bash /g2/tools/mkhist.sh 20180901 20180915 > 2020-05-08_01.lst
	bash /g2/tools/mkhist.sh 20180916 20180930 > 2020-05-07_01.lst
	bash /g2/tools/mkhist.sh 20181001 20181015 > 2020-05-06_01.lst
	bash /g2/tools/mkhist.sh 20181016 20181031 > 2020-05-05_01.lst
	bash /g2/tools/mkhist.sh 20181101 20181115 > 2020-05-04_01.lst
	bash /g2/tools/mkhist.sh 20181116 20181130 > 2020-05-03_01.lst
	bash /g2/tools/mkhist.sh 20181201 20181215 > 2020-05-02_01.lst
	bash /g2/tools/mkhist.sh 20181216 20181231 > 2020-05-01_01.lst
	
	
	
	bash /g2/tools/mkhist.sh 20180916 20180930 > 2020-05-23_01.lst
	bash /g2/tools/mkhist.sh 20180916 20180930 > 2020-05-24_01.lst
	bash /g2/tools/mkhist.sh 20180916 20180930 > 2020-05-25_01.lst
	bash /g2/tools/mkhist.sh 20180916 20180930 > 2020-05-26_01.lst

	
	
}

if (( $# > 0 && $1 == 2019 )); then
	do_2019
	exit
fi

if (( $# >= 1 )); then
	dstart=$1
fi
if (( $# >= 2 )); then
	dstop=$2
fi

do_make $dstart $dstop
