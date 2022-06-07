#!/bin/sh
source env.sh

echo $REDIS_PATH

for port in $(seq 7379 7384); do
  echo "Starting ... $port"
  cd $port
  $REDIS_PATH/$REDIS_SERVER redis.conf
  cd ..
done
