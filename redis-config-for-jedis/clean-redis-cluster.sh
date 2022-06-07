#!/bin/sh
source env.sh

echo $REDIS_PATH

for port in $(seq 7379 7384); do
  echo "Cleaning ... $port"
  rm $port/appendonly.aof
  rm $port/nodes.conf
  rm $port/dump.rdb
done
