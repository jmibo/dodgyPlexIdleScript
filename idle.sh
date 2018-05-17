#!/bin/bash
CPUIdleMax=2
IdleTime=15
Counter=$(cat counter.txt)
Usage=$(awk -v a="$(awk '/cpu /{print $2+$4,$2+$4+$5}' /proc/stat; sleep 1)" '/cpu /{split(a,b," "); print 100*($2+$4-b[1])/($2+$4+$5-b[2])}'  /proc/stat)
Usage=${Usage%.*}

if [ -z $Counter ];then
        Counter=0
fi

if [ $Usage -gt $CPUIdleMax ]; then
        Counter=0
else
        Counter=$((Counter+1))
fi

if [ $Counter -ge $IdleTime ];then
        echo "Shutdown"
        Counter=0
        echo $Counter > counter.txt
        shutdown now
fi

echo $Counter > counter.txt
