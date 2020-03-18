## Runloop

** [源码参考](https://github.com/apple/swift-corelibs-foundation/blob/5e27d971d04268d9cf6eee3445dc70c0736eaed4/CoreFoundation/RunLoop.subproj/CFRunLoop.c)**

---
**如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒**
```
Run loops are part of the fundamental infrastructure associated with threads. A run loop is an event processing loop that you use to schedule work and coordinate the receipt of incoming events. The purpose of a run loop is to keep your thread busy when there is work to do and put your thread to sleep when there is none.
```

---
### app如何接收到触摸事件的
苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。这个过程的详细情况可以参考这里。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
_UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。

### 为什么只有主线程的runloop是开启的
1、线程脱离runloop就会挂，所以如果主线程挂了，app就等于是：启动就挂掉

2、为了使app能时刻响应，所以程序启动时，默认创建了主线程的runloop，并使用字典保存。

3、其他线程都是为了处理临时性的任务，用完就会释放，对应的runloop通过懒加载获取。

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