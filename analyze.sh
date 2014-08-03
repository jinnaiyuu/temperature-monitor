#!/bin/bash

# Analyze the current temperature of the cluster.
# Log files are written by cron job of aflab-lucy and aflab-00X.  
# 
# This script does
#
# 1. Parse the log files of each nodes.
# 2. Get the average and maxium of the temperature.
# 3. If its in danger, mail to everybody. (in mail_hot.py)
#

# Temperature to send mail
# TODO: Ad hoc value. Need to find the proper temperature.
DANGER_AVRG_TEMP=100.0
DANGER_MAX_TEMP=120.0



# If there any arguments, debug mode is on (this script is harmless and its easier to understand by running this).

if [ $# -ge 1 ]
then
    _DEBUG="on"
fi

# Lines with DEBUG in front are debug mode commands.

function DEBUG()
{
    [ "$_DEBUG" == "on" ] && $@
}



date >> /home/log_of_funcluster/jinnai/stat.log

# Explicitly iterating over log files in order to manipulate which nodes to take into account
# For now, fun000 & fun006 is not working.
# Lots of duplicates for now
for file in /home/log_of_funcluster/jinnai/fun-lucy/temperature.log /home/log_of_funcluster/jinnai/fun000/temperature.log /home/log_of_funcluster/jinnai/fun001/temperature.log /home/log_of_funcluster/jinnai/fun002/temperature.log /home/log_of_funcluster/jinnai/fun003/temperature.log /home/log_of_funcluster/jinnai/fun004/temperature.log /home/log_of_funcluster/jinnai/fun005/temperature.log /home/log_of_funcluster/jinnai/fun006/temperature.log /home/log_of_funcluster/jinnai/fun007/temperature.log
do
#    file=/home/log_of_funcluster/jinnai/`host`/temperature.log
    # if there exists a file
    if [ -e $file ]
    then
	# Lucy has different sensor monitor to other nodes. Therefore the data structure differs from others.
	if [ $file = /home/log_of_funcluster/jinnai/fun-lucy/temperature.log ]
	then
	    sample=4
	    h=8
	else
	    sample=8
	    h=6
	fi
	DEBUG echo "in file : " $file
	length=$(awk ' END { print NR }' $file)
	DEBUG echo "length of the log = " $length
	
	# This is obviously inefficient way to process.
	# This script runs in lucy, but if it takes so long we have to improve here as these two lines are the core of this application.
	avrg=`awk -v l=$length -v smpl=$sample ' BEGIN {sum=0} NR>l-smpl { sum+=$2} END { print sum/smpl } ' $file` 
	max=`awk -v l=$length -v smpl=$sample ' BEGIN {max=0} NR>l-smpl { max=max>$2?max:$2 } END { print max } ' $file`

	DEBUG echo "in file " ${file:31:$h} "sum, max of the log = " $avrg $max
	echo ${file:31:$h} $avrg $max >> /home/log_of_funcluster/jinnai/stat.log
	a=$(echo "$avrg > $DANGER_AVRG_TEMP" | bc)
	b=$(echo "$max > $DANGER_MAX_TEMP" | bc)
	DEBUG echo "avrg danger?" $a 
	DEBUG echo "max danger?" $b   

	# If avrg or max is beyond the threashould, send mail to members.
	if [ $a -ge 1 -o $b -ge 1 ]
	then
	    /home/log_of_funcluster/jinnai/mail_hot.py $avrg $max
	fi
	DEBUG echo 
    fi
done



# The output format is 
#
# Date
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
# 
# Date
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
# <name of node> <average> <max>
#         ......and so on.
#
# Date is currenlty in natural language.





