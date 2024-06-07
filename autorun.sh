#!/bin/bash
source /etc/profile
#这是你的venv路径 ~/samsung/streamrecorder/ 记得按自己的改
#如果你的streamlink直接安装在系统，就把下面这行删了
source ~/samsung/streamrecorder/bin/activate
cd `dirname $0`
LOG_PREFIX=$(date +"[%Y-%m-%d %H:%M:%S]")
LOG_SUFFIX=$(date +"%Y%m%d_%H%M%S")
for ((NUM=$(ls ./config|grep -v global|grep -c .config); NUM>0; --NUM))
do
NAME=$(ls ./config|grep .config|grep -v global|sed 's/.config//g'|sed -n "$NUM"p)
if [ -z "$(screen -ls|grep $NAME)" ]
then
sleep 1
screen -L -t ${NAME}_${LOG_SUFFIX} -dmS $NAME ./controller.sh $NAME
sleep 1
echo "$LOG_PREFIX ===autorun=== running new screen for $NAME"
echo "$LOG_PREFIX ===autorun=== check ./log/screen/screenlog_${NAME}_${LOG_SUFFIX}.log for detail"
else
echo "$LOG_PREFIX ===autorun=== skip...screen for $NAME already running"
fi
done
