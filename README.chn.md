# Redis Cluster支持mget/mset等批量操作
让Redis集群支持批量操作，对于分布于相同节点上，但位于不同的slot内的key不再进行限制。

### Redis使用版本
测试基于Redis@3.2.12版本进行。通过了Redis官方的全部测试用例。

### Jedis使用版本
测试基于Jedis@3.3.0版本进行。测试通过了Jedis官方的全部测试用例。

### mgetSeries/msetSeries方法
* mgetSeries方法使用方式同mget方法
* mgetSeries方法无需关注key的分布情况，方法内部对key根据slot和节点进行分组。依次在每个节点上执行mget
* mgetSeries和msetSeries在任意节点失败，都会抛出异常。

### ChangeLog

* Jedis新增方法mgetSeries/msetSeries
* 基于JedisPool封装RedisClient
