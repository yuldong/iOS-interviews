### load 与 initialize
---
#### load、initialize方法的区别什么？在继承关系中他们有什么区别

**调用时机**

load 会在在main执行之前通过runtime执行，执行顺序为 父类、子类、分类；

load肯定会执行且只会执行一次；

**执行方式**
``` C
(*load_method)(cls, SEL_load);
```

**调用时机**

initialize是类第一次接收到消息时调用；执行顺序为父类、子类；

initialize可能一次都不执行，每个类只初始化一次；

**执行方式**
``` C
((void(*)(Class, SEL))objc_msgSend)(cls, SEL_initialize);
```
**因为走的消息发送，如果子类没有实现该方法时，会调用父类的此方法（所以父类此方法被执行多次的情况）；一般会使用 self == Object.class来避免**