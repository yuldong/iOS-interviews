### 内存管理
**[源码参考 GUN](https://github.com/gnustep/libs-base/tree/master)**

**[源码参考](https://github.com/RetVal/objc-runtime)**

---

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

Tagged Pointers

#### ARC下哪些情况会造成内存泄漏
**CF, Block, delegate, NSTimer、CADisplaylink**

#### 参考
- [深入理解 Tagged Pointer](https://www.infoq.cn/article/deep-understanding-of-tagged-pointer/)
- [Tagged Pointer技术](https://www.mikeash.com/pyblog/friday-qa-2012-07-27-lets-build-tagged-pointers.html) **推荐**
- [Tagged Pointer 官方视频](https://developer.apple.com/videos/play/wwdc2013/404/)