## Runtime
---
### 结构模型
#### 介绍下runtime的内存模型（isa、对象、类、metaclass、结构体的存储信息等）
``` C
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};
struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
};
```

#### 为什么要设计metaclass
通过meta class创建类对象
#### class_copyIvarList & class_copyPropertyList区别
``` C
struct property_t {
    const char *name;
    const char *attributes;
};
struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    // alignment is sometimes -1; use alignment() instead
    uint32_t alignment_raw;
    uint32_t size;

    uint32_t alignment() const {
        if (alignment_raw == ~(uint32_t)0) return 1U << WORD_SHIFT;
        return 1 << alignment_raw;
    }
};
```
#### class_rw_t 和 class_ro_t 的区别
#### category如何被加载的,两个category的load方法的加载顺序，两个category的同名方法的加载顺序
category 中的load都会执行，执行顺序可以在 compile source中调整。

category 中的同名方法会同时被保存到 class_rw_t 中

#### category & extension区别，能给NSObject添加Extension吗，结果如何
category是runtime动态添加到类中，extension在编译时已经绑定到所属类

#### 消息转发机制，消息转发机制和其他语言的消息机制优劣对比
objc_msgSend流程: 判断receiver是否为nil，获取isa，cache查找，lookUpImpOrForward -> method list查找，按照继承链查找，resolveMethod，_objc_msgForward_impcache

消息转发: forwardingTargetForSelector 转发到其他对象，则重复走上述的 `objc_msgSend流程`。再走methodSignatureForSelector: 方法。随后走forwardInvocation:方法。

#### IMP、SEL、Method的区别和使用场景
IMP: typedef void (*IMP)(void /* id, SEL, ... */ ); 函数指针，函数的真正执行地址

SEL: typedef struct objc_selector *SEL; 一个const char *字符串常量，只代表一个名字
``` C
static const char *sel_cname(SEL sel) {
    return (const char *)(void *)sel;
}
```

Method: typedef struct objc_method *Method; 包含了SEL以及IMP

#### load、initialize方法的区别什么？在继承关系中他们有什么区别
load 是app运行时，在main执行之前执行，执行顺序为 父类、子类、分类

initialize是类首次调用类所属方法时

load肯定会执行且只会执行一次，而initialize可能一次都不执行

initialize也可能会多次执行，所以一般会使用 self == Object.class来避免
### 内存管理
#### weak的实现原理？SideTable的结构是什么样的
#### 关联对象的应用？系统如何实现关联对象的
#### 关联对象的如何进行内存管理的？关联对象如何实现weak属性
#### Autoreleasepool的原理？所使用的的数据结构是什么
#### ARC的实现原理？ARC下对retain & release做了哪些优化
#### ARC下哪些情况会造成内存泄漏

### 其他
#### Method Swizzle注意事项
#### 属性修饰符atomic的内部实现是怎么样的?能保证线程安全吗
#### iOS 中内省的几个方法有哪些？内部实现原理是什么
判断类的类型: object_getClass
判断selector是否存在: lookUpImpOrNil
#### class、objc_getClass、object_getclass 方法有什么区别
class: self, object_getClass(self)
objc_getClass: look_up_class
object_getclass: obj->getIsa()

### 参考
- [Objective-C 中的消息与消息转发](https://blog.ibireme.com/2013/11/26/objective-c-messaging/)
- [RuntimePDF](https://github.com/DeveloperErenLiu/RuntimePDF)