HOST=localhost
. ~/.sqlpass

table=bd_feature
fromdate=2019-12-01
todate=2020-03-31
limits=20
order=desc
cmd=top
tblist=( "bd_feature" )

do_dcount(){
	curr=$fromdate
	end=$todate
	for((;;)); do
		for tb in "${tblist[@]}"; do
			table=$tb
			n=`sqlcmd -S $HOST -U $ACC -P $PASS -Q "select count ([importdate]) from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] = '${curr}' " |  sed 's/^ *//; /---/d; /affec/d; /^ *$/d'`
			echo $curr.$table.count = $n
		done
		if [ $curr == $end ]; then
			exit
		fi
		n=`date --date=${curr} +%s`
		n=$((n+24*60*60))
		curr=`date --date=@$n +%F`
	done
}

do_selectall(){
	curr=$fromdate
	end=$todate
	sqlcmd -S $HOST -U $ACC -P $PASS -Q "select * from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] between '${curr}' and '${end}'"
}

do_gen(){
	LST=( "os" "icos_bbi" "icos_bga" "icos_tpi" "icos_mark" "icos_lead" "icos_bottomleadless" "bd_feature" "bd_wbhistory" "bd_wboverview" "reliability" "rms" "era" "gui_iqa" )
	for s in "${LST[@]}"; do
		echo bash $0 --table=$s --fromdate=$fromdate --todate=$todate --dailycount
	done
}

do_delete(){
	for tb in "${tblist[@]}"; do
		table=$tb
		printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"delete from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' \"\n"
		continue
	done
}

do_trunc(){
	for tb in "${tblist[@]}"; do
		table=$tb
		printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"truncate table [GraphData_v0.7.5].[dbo].[${table}]  \"\n"
		continue
	done
}

do_alter_strip(){
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[STRIP] ALTER COLUMN [STRIP_START] DATETIME \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[STRIP] ALTER COLUMN [STRIP_END] DATETIME \"\n"
}

do_alter(){
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [CUST_NO] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [PKG_Type] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [BD_No] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Device_Name] nvarchar(2048)\"\n" 
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Lead_Count] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Wire_type] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Wire_diameter] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [RDL_Wafer] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Al_thickness] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Wafer_Source] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Wafer_Tech] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [SBS_LF_thickness] nvarchar(2048)\"\n" 
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Item] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [CUST_Req] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Sys_Risk] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [ENG_Risk] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Command] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [RA_No] nvarchar(2048) \"\n"
printf "sqlcmd -S $HOST -U $ACC -P $PASS -Q \"ALTER TABLE [GraphData_v0.7.5].[dbo].[ERA] ALTER COLUMN [Issuer] nvarchar(2048) \"\n"
}

for((;$# > 0;)); do
	arg=$1
	shift
	if [ ${arg:0:8} == --table= ]; then
		table=${arg:8}
		tblist=( $table )
		continue
	fi
	if [ $arg == =all ]; then
		tblist=( os bd_feature bd_wboverview bd_wbhistory icos_bbi icos_tpi icos_mark icos_lead icos_bga icos_bottomleadless "reliability" "rms" "era" "gui_iqa" )  
		continue
	fi
	if [ $arg == =icos ]; then
		tblist=( icos_bbi icos_tpi icos_mark icos_lead icos_bga icos_bottomleadless )
		continue
	fi
	if [ $arg == =dxf ]; then
		tblist=( bd_feature bd_wboverview bd_wbhistory )
		continue
	fi
	if [ ${arg:0:1} == + ]; then
		tblist+=( ${arg:1} )
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
	if [ ${arg:0:4} == --fd ]; then
		fromdate=${arg:4}
		continue
	fi
	if [ ${arg:0:9} == --todate= ]; then
		todate=${arg:9}
		continue
	fi
	if [ ${arg:0:4} == --td ]; then
		todate=${arg:4}
		continue
	fi
	if [ $arg == --count ]; then
		sqlcmd -S $HOST -U $ACC -P $PASS -Q "select count ([importdate]) from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' "
		continue
	fi
	if [ $arg == --top ]; then
		sqlcmd -S $HOST -U $ACC -P $PASS -Q "select top (${limits}) [importdate] from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' order by [importdate] ${order}"
		continue
	fi
	if [ $arg == --alltop ]; then
		sqlcmd -S $HOST -U $ACC -P $PASS -Q "select top (${limits}) [importdate] from [GraphData_v0.7.5].[dbo].[${table}] order by [importdate] ${order}"
		continue
	fi
	if [ $arg == --delete ]; then
		do_delete
		continue
	fi
	if [ $arg == --truncate ]; then
		do_trunc
		continue
	fi
	if [ $arg == --dailycount ] || [ $arg == --dc ] ; then
		do_dcount
		continue
	fi
	if [ $arg == --select-all ] || [ $arg == --sa ] ; then
		do_selectall
		continue
	fi
	if [ $arg == --nobd ]; then
		table=bd_feature
		sqlcmd -S $HOST -U $ACC -P $PASS -Q "select top (${limits}) [importdate],[bd_no] from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' and [bd_no] is null order by [importdate] ${order}"
		continue
	fi
	if [ $arg == --bd ]; then
		table=bd_feature
		sqlcmd -S $HOST -U $ACC -P $PASS -Q "select top (${limits}) [importdate],[bd_no] from [GraphData_v0.7.5].[dbo].[${table}] where [importdate] >= '${fromdate}' and [importdate] <= '${todate}' and [bd_no] is not null order by [importdate] ${order}"
		continue
	fi
	if [ $arg == --gen ]; then
		do_gen
		continue
	fi
	if [ $arg == xalter ]; then
		do_alter
	fi
	if [ $arg == --alter-strip ]; then
		do_alter_strip
	fi
done

exit

