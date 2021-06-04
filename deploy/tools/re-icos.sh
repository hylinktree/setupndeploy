#!/bin/bash
for((i=1201;i<1226;i++)) do
	echo mv ICOS_2019${i}.tgz ICOS_2019${i}_20200101.tgz
	#ls ICOS_2019${i}*.tgz
	#y=`ls ICOS_2019${i}*.tar.gz`
	#echo mv $y ICOS_2019${i}.tgz
done

