## KVO 

** [源码参考](https://github.com/gnustep/libs-base/tree/master) **

---
### 实现原理
**基于libs-base源码探究**
step1: 动态创建子类并添加父类Behavior

step2: class 替换 [object_setClass(id obj, Class cls)] 

```
1、step2 修改 instance的isa指向, 所以真实的set方法走到了子类
2、重写class方法，隐藏内部实现
```

step3: override keyPath对应的set方法

set方法调用: 
``` Objective-C
{
    // pre setting code here
    [self willChangeValueForKey: key];
    (*imp)(self, _cmd, val);
    // post setting code here
    [self didChangeValueForKey: key];
}
```

step4: 注册

### 如何手动关闭kvo
核心代码: 
```
+ (BOOL) automaticallyNotifiesObserversForKey: (NSString*)aKey;
```

### 通过KVC修改属性会触发KVO么
KVC原理: 

set -> 优先根据[setKey:、_setKey:]method进行赋值

**再判断**
``` C
+ (BOOL) accessInstanceVariablesDirectly
```
顺序判断 _key、_isKey、key、isKey 成员变量

get: -> getKey, key, isKey,

**再判断**
``` C
+ (BOOL) accessInstanceVariablesDirectly
```
顺序判断 _getKey, _key, _isKey, key, isKey

### 哪些情况下使用kvo会崩溃，怎么防护崩溃
- KVO的被观察者dealloc时仍然注册着KVO导致的crash
- KVO注册观察者与移除观察者不匹配

### kvo的优缺点
```
KVO’s primary benefit is that you don’t have to implement your own scheme to send notifications every time a property changes. Its well-defined infrastructure has framework-level support that makes it easy to adopt—typically you do not have to add any code to your project. In addition, the infrastructure is already full-featured, which makes it easy to support multiple observers for a single property, as well as dependent values.
```
- 重复移除会崩溃
- dealloc不会自动移除
- 未提供判断一个对象是否是观察者或被观察者的方式
- to-one, to-many的实现(不明)

### 参考
- [KVO 进阶 —— 源码实现探究](https://juejin.im/entry/58243f0f0ce4630058b20f59)
- [如何手动实现一个KVO](https://tech.glowing.com/cn/implement-kvo/)
- [DIS_KVC_KVO](https://github.com/renjinkui2719/DIS_KVC_KVO)
- [iOS 开发：『Crash 防护系统』（二）KVO 防护](https://bujige.net/blog/iOS-YSCDefender-02.html)
- [iOS底层原理总结篇-- 深入理解 KVC\KVO 实现机制](https://juejin.im/post/5c2189dee51d454517589c8b)
- [官方解释](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177i)