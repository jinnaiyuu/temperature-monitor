date >> /home/log_of_funcluster/jinnai/`hostname`/temperature.log

echo `hostname` >> /home/log_of_funcluster/jinnai/`hostname`/temperature.log

if [ `hostname` = "fun-lucy" ]
then
    sensors | awk '/Core/{ print substr($2,0,1), substr($3,2,4) }' >> /home/log_of_funcluster/jinnai/`hostname`/temperature.log
else
    sensors | awk '/DIMM/{ print substr($2,0,1), substr($5,2,4) }' >> /home/log_of_funcluster/jinnai/`hostname`/temperature.log
fi

#sensors ;mpstat -P ALL | awk ' NR>4 { print $3} ' 

