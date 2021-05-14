## concurrent

**[源码参考 Foundation](https://github.com/apple/swift-corelibs-foundation)**

**[源码参考 libdispatch](https://github.com/apple/swift-corelibs-libdispatch)**

**[源码参考 GUN](https://github.com/gnustep/libs-base/tree/master)**

**串行与并行、同步与异步**

**同步完成多项任务，通过提高系统的资源利用率来提高系统的效率**

---

### iOS开发中有多少类型的线程？分别对比
pthread： C语言框架，跨平台，基本不用。手动管理生命周期。

NSThread: pthread的封装，面向对象，比较少用，debug。手动管理生命周期。
不太适合复杂任务，比如涉及线程状态、线程依赖、线程同步等。

**GCD**: 优化应用程序以支持多核处理器，自动管理线程的生命周期，不需要编写任何线程管理代码。
控制起来比较麻烦，比如取消一个线程。无法对任务设置优先级。
- serial queue
- concurrent queue
**Apple推荐**

NSOperation: 面向对象，对gcd的封装，可进行取消、暂停操作，配合queue可以对任务设置优先级

**需要更细粒度的线程控制，推荐**

### GCD有哪些队列，默认提供哪些队列
serial、concurrent、main、global

|  ---  | mainQueue | serialQueue | globalQueue |
| :---: | :-------: | :---------: | :---------: |
| sync  |   main    |   current   |   current   |
| async |   main    |     new     |     new     |

队列决定任务执行顺序，sync, async决定是否开启新线程；

### GCD有哪些方法api
dispatch_sync、dispatch_async、dispatch_barrier_async、dispatch_after、dispatch_once、dispatch_apply、dispatch_group_async、dispatch_semaphore

### 主线程 & 主队列的关系


### 如何实现同步，有多少方式就说多少
group、semaphore、串行队列、加锁、barrier

### dispatch_once实现原理
系统级的信号量

### 什么情况下会死锁
相互等待，比如同步任务增加同步任务。

> 禁止抢占（no preemption）：系统资源不能被强制从一个进程中退出。
> 
> 持有和等待（hold and wait）：一个进程可以在等待时持有系统资源。
> 
> 互斥（mutual exclusion）：资源只能同时分配给一个行程，无法多个行程共享。
> 
> 循环等待（circular waiting）：一系列进程互相持有其他进程所需要的资源。

### 有哪些类型的线程锁，分别介绍下作用和使用场景

- 互斥锁 `线程会进入休眠状态等待锁，等待被唤醒`
  - os_unfair_lock 用于取代 OSSpinLock
  - pthread_mutex 互斥锁，等待锁的线程会处于休眠状态
  - NSLock、NSRecursiveLock pthread_mutex的封装
  - NSCondition pthread_mutex + pthread_cond的封装
  - NSConditionLock `internal var _cond = NSCondition()`  对NSCondition的进一步封装，可以增加具体的条件
  - @synchronized 底层，使用传进去的对象生成一对一的锁，并用hash表存起来。723版本使用 `pthread_mutex`，从750版本使用 `os_unfair_lock`

- 自旋锁 `线程等待锁的线程仍然占用CPU资源，即忙等`
  - OSSpinLock 可能会造成优先级反转

- dispatch_semaphore
  通过`dispatch_semaphore_wait`与`dispatch_semaphore_signal`控制可访问线程的数量来达到同步的目的


### 属性修饰符atomic的内部实现是怎么样的? 能保证线程安全吗?
spinlock_t，真实底层实现为mutex_t中的os_unfair_lock。

能保证属性自身的读写是安全的，但不能保证属性内的值读写是安全的。

### NSOperationQueue中的maxConcurrentOperationCount默认值
-1，表示不进行限制，由NSOperationQueue根据系统状态动态确定，支持并发操作。

### NSTimer、CADisplayLink、dispatch_source_t 的优劣
前两者依赖runloop执行，作为timesource塞进mode中的集合中。

后者不依赖runloop，系统级，可取消。

### GCD
|       种类       |           说明           |
| :--------------: | :----------------------: |
|   serial Queue   |  等待现在执行中处理结束  |
| concurrent Queue | 不等待现在执行中处理结束 |

> 用于管理追加的Block的C语言实现的FIFO队列
> 
> Atomic函数中实现的用于排他控制的轻量级信号
> 
> 用于管理线程的C语言层实现的一些容器

### 参考
- [iOS 多线程编程知识整理](https://dnduuhn.com/2018/12/02/iOS-%E5%A4%9A%E7%BA%BF%E7%A8%8B%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86%E6%95%B4%E7%90%86/)
- [iOS多线程编程总结](https://bestswifter.com/multithreadconclusion/)
- [浅谈iOS多线程(源码)](https://leylfl.github.io/2018/01/16/%E6%B5%85%E8%B0%88iOS%E5%A4%9A%E7%BA%BF%E7%A8%8B-%E6%BA%90%E7%A0%81/)
- [iOS开发中深入理解CADisplayLink和NSTimer](http://www.codeceo.com/article/ios-cadisplaylink-nstimer.html)