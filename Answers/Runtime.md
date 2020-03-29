## Runtime

**[源码参考](https://github.com/RetVal/objc-runtime)**

---
### 结构模型
#### 介绍下runtime的内存模型（isa、对象、类、metaclass、结构体的存储信息等）
``` C
struct objc_object {
private:
    isa_t isa;
}
struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
};
```

#### 为什么要设计metaclass
通过meta-class创建类对象

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

#### 消息发送，消息转发机制和其他语言的消息机制优劣对比
objc_msgSend流程: 判断receiver是否为nil，获取isa，cache查找，lookUpImpOrForward -> method list查找(线性或者二分查找)，按照继承链(superclass)查找，走动态解析；

动态解析: resolveMethod，再走method list查找，按照继承链(superclass)查找，走消息转发；

消息转发: forwardingTargetForSelector 转发到其他对象，重复走上述的 `objc_msgSend流程`。再走methodSignatureForSelector: 方法 -> 随后走forwardInvocation:方法。

#### IMP、SEL、Method的区别和使用场景
IMP: typedef void (*IMP)(void /* id, SEL, ... */ ); 函数指针，函数的真正执行地址

SEL: typedef struct objc_selector *SEL; 一个const char *字符串常量，只代表一个名字
``` C
static const char *sel_cname(SEL sel) {
    return (const char *)(void *)sel;
}
```

Method: typedef struct objc_method *Method; 包含了SEL以及IMP

### 内存管理
#### weak的实现原理？SideTable的结构是什么样的
SideTables[obj];
``` C
template <HaveOld haveOld, HaveNew haveNew,
          CrashIfDeallocating crashIfDeallocating>
static id storeWeak(id *location, objc_object *newObj);

struct SideTable {
    spinlock_t slock;
    RefcountMap refcnts;
    weak_table_t weak_table; // 
}
struct weak_table_t {
    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};
struct weak_entry_t {
    DisguisedPtr<objc_object> referent;
    union {
        struct {
            weak_referrer_t *referrers;
            uintptr_t        out_of_line_ness : 2;
            uintptr_t        num_refs : PTR_MINUS_2;
            uintptr_t        mask;
            uintptr_t        max_hash_displacement;
        };
        struct {
            // out_of_line_ness field is low bits of inline_referrers[1]
            weak_referrer_t  inline_referrers[WEAK_INLINE_COUNT];
        };
    };
};
```

#### Autoreleasepool的原理？所使用的的数据结构是什么
AutoreleasePoolPage 为结点的双向链表
``` C++
static inline void *push();
static inline void pop(void *token);
static inline id *autoreleaseFast(id obj);
```

#### ARC的实现原理？ARC下对retain & release做了哪些优化
对不同的变量修饰符，编译器在合适的位置插入相应的代码来管理内存(引用计数)。
TaggedPointer
#### ARC下哪些情况会造成内存泄漏
CF, Block, delegate, NSTimer
### 其他

#### Method Swizzle注意事项
执行交换的位置以及次数，load + dispatch_once

分类的load执行

#### iOS 中内省的几个方法有哪些？内部实现原理是什么
判断类的类型: object_getClass
判断selector是否存在: lookUpImpOrNil
#### class、objc_getClass、object_getclass 方法有什么区别
class: self, object_getClass(self)
objc_getClass: look_up_class
object_getclass: obj->getIsa()

#### super
``` C
struct objc_super {
    /// Specifies an instance of a class.
    __unsafe_unretained _Nonnull id receiver;

    /// Specifies the particular superclass of the instance to message. 
    __unsafe_unretained _Nonnull Class super_class;
#endif
    /* super_class is the first class to search */
};

objc_msgSendSuper(struct objc_super * _Nonnull super, SEL _Nonnull op, ...);

```
**the superclass at which to start searching for the method implementation**

#### 用处
- 字典转模型 YYModel, MJExtension
- 方法交换, Hook, Aspects
- 关联对象, Associated
- KVC
- OC动态性由runtime支撑和实现

### 参考
- [Objective-C 中的消息与消息转发](https://blog.ibireme.com/2013/11/26/objective-c-messaging/)
- [RuntimePDF](https://github.com/DeveloperErenLiu/RuntimePDF)
- [源码分析 weak 对象自动置空原理](https://debugly.cn/2017/07/17-objc-weak-obj-imp.html)
- [Objective-C Autorelease Pool 的实现原理](http://blog.leichunfeng.com/blog/2015/05/31/objective-c-autorelease-pool-implementation-principle/)
- [理解 ARC 实现原理](https://juejin.im/post/5ce2b7386fb9a07eff005b4c)