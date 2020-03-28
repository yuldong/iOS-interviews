## Block

**[源码参考](https://github.com/apple/swift-corelibs-foundation)**

**编译命令: xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc filename.m**

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
    // 捕获对象时，编译器会增加对'variables'的内存管理方法
};
```

### block是类吗，有哪些类型
** OC 对象，继承自NSBlock: NSObject ** 封装了函数调用以及函数调用环境。
- NSGlobalBlock 在block内部不使用局部变量或者为静态或者全局变量。
- NSStackBlock block内部使用了auto修饰符的都是 NSStackBlock类型
- NSMallocBlock NSStackBlock调用copy得到的就是NSMallocBlock类型。

### Block访问对象类型的auto变量时，在ARC和MRC下有什么区别
ARC下会进行一次copy，stack变成malloc

### 一个int变量被 __block 修饰与否的区别？block的变量截获
**auto** **理解变量的生命周期**

局部变量都会捕获，对于静态变量 转化为指针，非静态变量，一份新的值。

全局变量 不捕获，直接访问

__block auto变量 转为Block_byref 结构体，其中会新增auto变量以及对应的内存管理方法

``` C
struct Block_byref {
    void *isa;
    // 指向自己的指针
    struct Block_byref *forwarding;
    volatile int32_t flags; // contains ref count
    uint32_t size;
    // imported variables
    // 如果auto变量为对象，编译器会增加'variables'内存管理方法
};

```
**注意: block外部访问的auto变量数据 为 Block_byref内 'imported variables'的数据**

### block在修改NSMutableArray，需不需要添加__block
如果是对数组内修改不需要。如果是修改数组本身，则需要。

### 怎么进行内存管理的
自身: _Block_copy, _Block_release

捕获变量: _Block_object_assign， _Block_object_dispose

**栈上block不会对auto变量进行强引用**

### block可以用strong修饰吗
可以，与copy一样

### 解决对象循环引用，为什么要用__weak, __strong
__weak, __block, __unsafe_unretained

**注意: __block 在ARC与MRC下的特殊性，ARC会强引用，MRC不会强引用**

__strong能保证捕获对象在block的生命周期内一直存在

### block发生copy时机
- 作为函数返回值
- 赋值给__strong指针时
- 系统的usingBlock
- GCD

### 参考
- [深入分析block](https://leylfl.github.io/2018/05/13/%E6%B7%B1%E5%85%A5%E5%88%86%E6%9E%90block/)
- [史上最详细的Block源码剖析](https://www.jianshu.com/p/d96d27819679)