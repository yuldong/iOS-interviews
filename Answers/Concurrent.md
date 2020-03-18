## concurrent

**串行与并行、同步与异步**

---

### iOS开发中有多少类型的线程？分别对比
pthread： C语言框架，跨平台，基本不用。手动管理生命周期。

thread: pthread的封装，面向对象，比较少用，debug。手动管理生命周期。
不太适合复杂任务，比如涉及线程状态、线程依赖、线程同步等。

**gcd**: 优化应用程序以支持多核处理器，自动管理线程的生命周期，不需要编写任何线程管理代码。
控制起来比较麻烦，比如取消和暂停一个线程。无法对任务设置优先级。
**Apple推荐**

nsoperation: 面向对象，对gcd的封装，可进行取消、暂停操作，配合queue可以对任务设置优先级

**需要更细粒度的线程控制，推荐**

### GCD有哪些队列，默认提供哪些队列
serial、concurrent、main、global

|  ---  | mainQueue | serialQueue | globalQueue |
| :---: | :-------: | :---------: | :---------: |
| sync  |   main    |   current   |   current   |
| async |   main    |     new     |     new     |

### GCD有哪些方法api
dispatch_sync、dispatch_async、dispatch_barrier_async、dispatch_after、dispatch_once、dispatch_apply、dispatch_group_async、dispatch_semaphore
### GCD主线程 & 主队列的关系
### 如何实现同步，有多少方式就说多少
group、barrier、semaphore
### dispatch_once实现原理

### 什么情况下会死锁
相互等待，比如同步任务增加同步任务。

### 有哪些类型的线程锁，分别介绍下作用和使用场景
@synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) 
### 属性修饰符atomic的内部实现是怎么样的?能保证线程安全吗
spinlock_t，真实底层实现为mutex_tt互斥锁。
### NSOperationQueue中的maxConcurrentOperationCount默认值
### NSTimer、CADisplayLink、dispatch_source_t 的优劣
前两者依赖runloop执行，作为timesource塞进mode中的集合中。
后者不依赖runloop，系统级，可取消。


### 参考
- [iOS 多线程编程知识整理](https://dnduuhn.com/2018/12/02/iOS-%E5%A4%9A%E7%BA%BF%E7%A8%8B%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86%E6%95%B4%E7%90%86/)
- [iOS多线程编程总结](https://bestswifter.com/multithreadconclusion/)
- [浅谈iOS多线程(源码)](https://leylfl.github.io/2018/01/16/%E6%B5%85%E8%B0%88iOS%E5%A4%9A%E7%BA%BF%E7%A8%8B-%E6%BA%90%E7%A0%81/)
- [iOS开发中深入理解CADisplayLink和NSTimer](http://www.codeceo.com/article/ios-cadisplaylink-nstimer.html)