## Block
---
### block的内部实现，结构体是什么样的
``` C
struct Block_layout {
    void *isa;
    volatile int32_t flags; // contains ref count
    int32_t reserved; 
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 *descriptor;
    // imported variables
};
```

### block是类吗，有哪些类型
** OC 对象 **
- NSGlobalBlock 在block内部不使用外部变量或者为静态或者全局变量。
- NSStackBlock block内部使用了auto修饰符的都是 NSStackBlock类型
- NSMallocBlock NSStackBlock调用copy得到的就是NSMallocBlock类型。
### 一个int变量被 __block 修饰与否的区别？block的变量截获
静态变量 转化为指针

全局变量 不捕获，直接访问

__block 转为Block_byref 结构体
``` C
struct Block_byref {
    void *isa;
    struct Block_byref *forwarding;
    volatile int32_t flags; // contains ref count
    uint32_t size;
};
```

### block在修改NSMutableArray，需不需要添加__block
如果是对数组内修改不需要。如果是修改数组本身，则需要。
### 怎么进行内存管理的
自身: _Block_copy, _Block_release

捕获变量: _Block_object_assign， _Block_object_dispose
### block可以用strong修饰吗
可以，与copy一样
### 解决循环引用时为什么要用__strong、__weak修饰
ARC下的内存管理方式

### block发生copy时机

### Block访问对象类型的auto变量时，在ARC和MRC下有什么区别
ARC下会进行一次copy，stack变成malloc

### 参考
- [深入分析block](https://leylfl.github.io/2018/05/13/%E6%B7%B1%E5%85%A5%E5%88%86%E6%9E%90block/)
- [史上最详细的Block源码剖析](https://www.jianshu.com/p/d96d27819679)