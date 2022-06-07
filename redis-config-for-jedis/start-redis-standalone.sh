#!/bin/sh
source env.sh

cd 6379
$REDIS_PATH/$REDIS_SERVER redis.conf
cd ..

cd 6380
$REDIS_PATH/$REDIS_SERVER redis.conf
cd ..
