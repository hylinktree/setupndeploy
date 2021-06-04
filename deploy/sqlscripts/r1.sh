#!/bin/bash
script=/root/g2sql/s1.sh
for((;;)); do
date
ssh db1 bash $script --fromdate=2020-01-01 --todate=2020-01-06 --count
ssh db2 bash $script --fromdate=2020-01-01 --todate=2020-01-06 --count
sleep 30
done
exit

. ~/.sqlpass

table=bd_feature
fromdate=2020-01-01
todate=2020-01-31
limits=20
order=desc
cmd=top

for((;$# > 0;)); do
	arg=$1
	shift
	if [ ${arg:0:8} == --table= ]; then
		table=${arg:8}
		continue
	fi
	if [ ${arg:0:8} == --order= ]; then
		order=${arg:8}
		continue
	fi
	if [ ${arg:0:8} == --limit= ]; then
		limits=${arg:8}
		continue
	fi
	if [ ${arg:0:11} == --fromdate= ]; then
		fromdate=${arg:11}
		continue
	fi
	if [ ${arg:0:9} == --todate= ]; then
		todate=${arg:9}
		continue
	fi
	if [ $arg == --count ]; then
		sqlcmd -S localhost -U $ACC -P $PASS -Q "select count ([importdate]) from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' "
		continue
	fi
	if [ $arg == --top ]; then
		sqlcmd -S localhost -U $ACC -P $PASS -Q "select top (${limits}) [importdate] from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' order by [importdate] ${order}"
		continue
	fi
done

