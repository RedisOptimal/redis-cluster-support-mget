#!/bin/sh

pid_6379=`ps ax |grep redis-server | grep 6379 | awk -F ' ' '{print $1}'`
pid_6380=`ps ax |grep redis-server | grep 6380 | awk -F ' ' '{print $1}'`
kill -9 $pid_6379
kill -9 $pid_6380
