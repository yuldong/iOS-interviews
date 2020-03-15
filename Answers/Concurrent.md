## concurrent
---

### iOS开发中有多少类型的线程？分别对比
thread、gcd、nsoperation
### GCD有哪些队列，默认提供哪些队列
serial、concurrent
main、global
### GCD有哪些方法api
dispatch_sync、dispatch_async、dispatch_barrier_async、dispatch_after、dispatch_once、dispatch_apply、dispatch_group_async、dispatch_semaphore
### GCD主线程 & 主队列的关系
### 如何实现同步，有多少方式就说多少
group、barrier、semaphore
### dispatch_once实现原理
### 什么情况下会死锁
### 有哪些类型的线程锁，分别介绍下作用和使用场景
### NSOperationQueue中的maxConcurrentOperationCount默认值
### NSTimer、CADisplayLink、dispatch_source_t 的优劣

### 参考
- [iOS 多线程编程知识整理](https://dnduuhn.com/2018/12/02/iOS-%E5%A4%9A%E7%BA%BF%E7%A8%8B%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86%E6%95%B4%E7%90%86/)