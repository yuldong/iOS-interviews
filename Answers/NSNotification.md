## NSNotification
**[swift版本](https://github.com/apple/swift-corelibs-foundation)**
---

### 关键结构 以及 说明
``` swift
struct Notification {
    /// A tag identifying the notification.
    public var name: Name
    
    /// An object that the poster wishes to send to observers.
    ///
    /// Typically this is the object that posted the notification.
    public var object: Any?
    
    /// Storage for values or objects related to this notification.
    public var userInfo: [AnyHashable : Any]?
}

// observer, 起了个receiver的名字
class NSNotificationReceiver : NSObject {
    fileprivate var name: Notification.Name?
    fileprivate var block: ((Notification) -> Void)?
    fileprivate var sender: AnyObject?
    fileprivate var queue: OperationQueue?
}

private let _defaultCenter: NotificationCenter = NotificationCenter()
class NotificationCenter: NSObject {
    private lazy var _nilIdentifier: ObjectIdentifier = ObjectIdentifier(_observersLock)
    private lazy var _nilHashable: AnyHashable = AnyHashable(_nilIdentifier)
    
    // 核心数据结构，[Notification.name: [notification.object: [receiver: NSNotificationReceiver]]]
    private var _observers: [AnyHashable /* Notification.Name */ : [ObjectIdentifier /* object */ : [ObjectIdentifier /* notification receiver */ : NSNotificationReceiver]]]
    private let _observersLock = NSLock()

    // 默认的通知中心
    open class var `default`: NotificationCenter {
        return _defaultCenter
    }
}

class NotificationQueue: NSObject {

    internal typealias NotificationQueueList = NSMutableArray
    internal typealias NSNotificationListEntry = (Notification, [RunLoop.Mode]) // Notification ans list of modes the notification may be posted in.
    internal typealias NSNotificationList = [NSNotificationListEntry] // The list of notifications to post

    internal let notificationCenter: NotificationCenter
    internal var asapList = NSNotificationList()
    internal var idleList = NSNotificationList()
    internal lazy var idleRunloopObserver: CFRunLoopObserver = {
        return CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFOptionFlags(kCFRunLoopBeforeTimers), true, 0) {[weak self] observer, activity in
            self!.notifyQueues(.whenIdle)
        }
    }()
    internal lazy var asapRunloopObserver: CFRunLoopObserver = {
        return CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFOptionFlags(kCFRunLoopBeforeWaiting | kCFRunLoopExit), true, 0) {[weak self] observer, activity in
            self!.notifyQueues(.asap)
        }
    }()

    // The NSNotificationQueue instance is associated with current thread.
    // The _notificationQueueList represents a list of notification queues related to the current thread.
    private static var _notificationQueueList = NSThreadSpecific<NSMutableArray>()
    internal static var notificationQueueList: NotificationQueueList {
        return _notificationQueueList.get() {
            return NSMutableArray()
        }
    }

    // The default notification queue for the current thread.
    private static var _defaultQueue = NSThreadSpecific<NotificationQueue>()
    open class var `default`: NotificationQueue {
        return _defaultQueue.get() {
            return NotificationQueue(notificationCenter: NotificationCenter.default)
        }
    }
}
```

### 参考
[轻松过面：一文全解iOS通知机制(经典收藏)](https://juejin.im/post/5e5fc16df265da575155723b)