# Redis Cluster支持mget/mset等批量操作
[English Version](./README.md)


让Redis集群支持批量操作，对于分布于相同节点上，但位于不同的slot内的key不再进行限制。

### Redis使用版本
测试基于Redis@3.2.12版本进行。通过了Redis官方的全部测试用例。

### Jedis使用版本
测试基于Jedis@3.3.0版本进行。测试通过了Jedis官方的全部测试用例。

### 使用方法
#### 获取代码
```
git clone https://github.com/RedisOptimal/redis-cluster-support-mget.git
git submodule update --init
```
#### Redis补丁
[00-REDIS-CLUSTER-MULTI-COMMAND](./00-REDIS-CLUSTER-MULTI-COMMAND.patch) 


[03-REIDS-APPLE-SILCON-CHIP](./03-REIDS-APPLE-SILCON-CHIP.patch)
```
cd redis@3.2
# 此Patch为必须打的Patch。
git apply ../00-REDIS-CLUSTER-MULTI-COMMAND.patch
# 兼容Apple M1芯片无法编译的问题。不是M1芯片，不是低版本可不用打。
git apply ../03-REIDS-APPLE-SILCON-CHIP.patch
```
#### Jedis补丁
[01-JEDIS-JAVA-VERSION-UPGRADE-TO-8](./01-JEDIS-JAVA-VERSION-UPGRADE-TO-8.patch)


[02-JEDIS-SUPPORT-MGET-SERIES](./02-JEDIS-SUPPORT-MGET-SERIES.patch)


[04-JEDIS-SUPPORT-MSET-SERIES](./04-JEDIS-SUPPORT-MSET-SERIES.patch)


[05-JEDIS-MGET-MSET-TEST-CASES](./05-JEDIS-MGET-MSET-TEST-CASES.patch)
```
cd jedis@3
# 必须打，用到了λ表达式，需要升级JDK版本到8
git apply ../01-JEDIS-JAVA-VERSION-UPGRADE-TO-8.patch
# 合并支持mgetSeries代码
git apply ../02-JEDIS-SUPPORT-MGET-SERIES.patch
# 合并支持msetSeries代码，依赖02的mgetSeries
git apply ../04-JEDIS-SUPPORT-MSET-SERIES.patch
# mgetSeries/msetSeries测试用例
git apply ../05-JEDIS-MGET-MSET-TEST-CASES.patch
```

### 对于Redis的改造
redis cluster不支持mget/mset命令，由于不同的key位于不同的slot中。而在电商等实际场景中，hashtag又无法很好的满足商品维度的缓存设计。
对于redis cluster进行简单的改造，对于同一个节点node上不同的slot允许跨slot访问。
```
-                    if (slot != thisslot) {
+                    if (slot != thisslot && n != server.cluster->slots[thisslot]) {
```

### 对于Jedis的改造，增加mgetSeries/msetSeries方法
* mgetSeries方法使用方式同mget方法。
* mgetSeries方法无需关注key的分布情况，方法内部对key根据slot和节点进行分组。依次在每个节点上执行mget。
* mgetSeries和msetSeries在任意节点失败，都会抛出异常。

### ChangeLog

* Jedis新增方法mgetSeries/msetSeries
* 基于JedisPool封装RedisClient
