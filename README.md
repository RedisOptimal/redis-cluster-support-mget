# mget and mset for Redis cluster
[中文版本](./README.chn.md)


Redis Cluster support mget / mset and other multi command.

### Redis version
Use redis@3.2.12 for test.

### Jedis version
Use jedis@3.3.0 for test.

### Get the code

```
git clone https://github.com/RedisOptimal/redis-cluster-support-mget.git
git submodule update --init
```

### Redis Patch
[00-REDIS-CLUSTER-MULTI-COMMAND](./00-REDIS-CLUSTER-MULTI-COMMAND.patch) 
[03-REIDS-APPLE-SILCON-CHIP](./03-REIDS-APPLE-SILCON-CHIP.patch)
```
cd redis@3.2
# Redis cluster mget/mset required patch. Must be apply.
git apply ../00-REDIS-CLUSTER-MULTI-COMMAND.patch
# Fix redis lower version(3.2) can't build in Apple M1 Silicon Chip.
# https://github.com/redis/redis/issues/10420
git apply ../03-REIDS-APPLE-SILCON-CHIP.patch
```

### Patch Jedis
[01-JEDIS-JAVA-VERSION-UPGRADE-TO-8](./01-JEDIS-JAVA-VERSION-UPGRADE-TO-8.patch)
[02-JEDIS-SUPPORT-MGET-SERIES](./02-JEDIS-SUPPORT-MGET-SERIES.patch)
[04-JEDIS-SUPPORT-MSET-SERIES](./04-JEDIS-SUPPORT-MSET-SERIES.patch)
[05-JEDIS-MGET-MSET-TEST-CASES](./05-JEDIS-MGET-MSET-TEST-CASES.patch)
```
cd jedis@3
# Required patch, upgrade JDK VERSION.
git apply ../01-JEDIS-JAVA-VERSION-UPGRADE-TO-8.patch
# Required patch, let jedis support mget command.
git apply ../02-JEDIS-SUPPORT-MGET-SERIES.patch
# Let jedis support mset command. Need patch 01 and 02 first.
git apply ../04-JEDIS-SUPPORT-MSET-SERIES.patch
# Test case, test and improve it if you like.
git apply ../05-JEDIS-MGET-MSET-TEST-CASES.patch
```

### What I did
[Using multi-keys command in redis cluster will meet error CLUSTER_REDIR_CROSS_SLOT](https://github.com/redis/redis/issues/9576)

```
-                    if (slot != thisslot) {
+                    if (slot != thisslot && n != server.cluster->slots[thisslot]) {
```
Change the server and client to support slot from same node.