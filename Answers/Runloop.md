## Runloop

** [源码参考](https://github.com/apple/swift-corelibs-foundation/blob/5e27d971d04268d9cf6eee3445dc70c0736eaed4/CoreFoundation/RunLoop.subproj/CFRunLoop.c)**

---
``` C
struct __CFRunLoop {
    CFRuntimeBase _base;
    _CFRecursiveMutex _lock;			/* locked for accessing mode list */
    __CFPort _wakeUpPort;			// used for CFRunLoopWakeUp 
    Boolean _unused;
    volatile _per_run_data *_perRunData;              // reset for runs of the run loop
    _CFThreadRef _pthread;
    uint32_t _winthread;

    // RunLoop 都会自动将 _commonModeItems 里的 Source/Observer/Timer 同步到具有 “Common” 标记的所有Mode里
    CFMutableSetRef _commonModes;
    // 保存具有commonMode性质的item
    CFMutableSetRef _commonModeItems;

    // 当前运行的模式
    CFRunLoopModeRef _currentMode;
    // runloop 中所有模式
    CFMutableSetRef _modes;

    struct _block_item *_blocks_head;
    struct _block_item *_blocks_tail;
    CFAbsoluteTime _runTime;
    CFAbsoluteTime _sleepTime;
    CFTypeRef _counterpart;
    _Atomic(uint8_t) _fromTSD;
    CFLock_t _timerTSRLock;
};

struct __CFRunLoopMode {
    CFRuntimeBase _base;
    _CFRecursiveMutex _lock;	/* must have the run loop locked before locking this */
    CFStringRef _name;
    Boolean _stopped;
    char _padding[3];

    // 事件(用户、系统)
    CFMutableSetRef _sources0;
    CFMutableSetRef _sources1;
    // 监听 runloop 状态
    CFMutableArrayRef _observers;
    // 定时器相关
    CFMutableArrayRef _timers;

    CFMutableDictionaryRef _portToV1SourceMap;
    __CFPortSet _portSet;
    CFIndex _observerMask;
#if USE_DISPATCH_SOURCE_FOR_TIMERS
    dispatch_source_t _timerSource;
    dispatch_queue_t _queue;
    Boolean _timerFired; // set to true by the source when a timer has fired
    Boolean _dispatchTimerArmed;
#endif
#if USE_MK_TIMER_TOO
    __CFPort _timerPort;
    Boolean _mkTimerArmed;
#endif
    uint64_t _timerSoftDeadline; /* TSR */
    uint64_t _timerHardDeadline; /* TSR */
};

/* Run Loop Observer Activities */
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    // 即将进入
    kCFRunLoopEntry = (1UL << 0),
    // 处理timers
    kCFRunLoopBeforeTimers = (1UL << 1),
    // 处理source
    kCFRunLoopBeforeSources = (1UL << 2),
    // 进入休息
    kCFRunLoopBeforeWaiting = (1UL << 5),
    // 唤醒
    kCFRunLoopAfterWaiting = (1UL << 6),
    // 退出
    kCFRunLoopExit = (1UL << 7),
    kCFRunLoopAllActivities = 0x0FFFFFFFU
};

```
**如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒**
```
Run loops are part of the fundamental infrastructure associated with threads. A run loop is an event processing loop that you use to schedule work and coordinate the receipt of incoming events. The purpose of a run loop is to keep your thread busy when there is work to do and put your thread to sleep when there is none.
```
这里有个概念叫 “CommonModes”：一个 Mode 可以将自己标记为”Common”属性（通过将其 ModeName 添加到 RunLoop 的 “commonModes” 中）。每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 _commonModeItems 里的 Source/Observer/Timer 同步到具有 “Common” 标记的所有Mode里。
---
### app如何接收到触摸事件的
苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。这个过程的详细情况可以参考这里。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
_UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。

### 为什么只有主线程的runloop是开启的
1、线程脱离runloop就会挂，所以如果主线程挂了，app就等于是：启动就挂掉

2、为了使app能时刻响应，所以程序启动时，默认创建了主线程的runloop，并使用字典保存。

3、其他线程都是为了处理临时性的任务，用完就会释放，对应的runloop通过懒加载获取。

4、定时器、GCD的block切换到主线程依赖于runloop、事件响应、手势识别、界面刷新、网络请求、autoreleasepool都是基于runloop的存在才能实现。

### performSelector: onThread: 和runloop的关系
1、当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。

2、当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。 **??**

### 如何使线程保活
线程做完事情，默认就会被干掉。
1、主线程是因为被加入到runloop中，而runloop中因为被注册了很多item，所以不会销毁，所以主线程会常驻。
2、在线程中获取runloop，然后在使runloop无限执行下去(通过设置超时时间)

### 应用

- Use ports or custom input sources to communicate with other threads.
- Use timers on the thread.
- Use any of the performSelector… methods in a Cocoa application.
- Keep the thread around to perform periodic tasks.


### 参考
- [关于RunLoop你想知道的事](https://zhuanlan.zhihu.com/p/62605958)
- [iOS RunLoop详解](https://juejin.im/post/5aca2b0a6fb9a028d700e1f8)
- [RunLoop 详解](http://sunshineyg888.github.io/2016/05/21/RunLoop-%E8%AF%A6%E8%A7%A3/)
- [Run Loop 记录与源码注释](https://github.com/Desgard/iOS-Source-Probe/blob/master/Objective-C/Foundation/Run%20Loop%20%E8%AE%B0%E5%BD%95%E4%B8%8E%E6%BA%90%E7%A0%81%E6%B3%A8%E9%87%8A.md)
- [深入理解RunLoop](https://blog.ibireme.com/2015/05/18/runloop/)
- [揭秘Runloop](http://mrpeak.cn/blog/ios-runloop/)
- [官方指导](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW1)