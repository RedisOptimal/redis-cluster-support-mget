#!/bin/sh
for pid in $(ps -ax | grep redis-server | grep cluster | awk -F ' ' '{print $1}'); do
  echo "Killing ... $pid"
  kill -9 $pid
done

