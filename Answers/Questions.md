### 讲一下内存管理的关键字？strong 和 copy 的区别
assgin: 用来修饰基本类型，作用于对象时，retaincount为0时，不置为nil

weak: 对象使用，用来避免循环引用，retaincount为0时，置为nil。sidetable中的weak_table

strong： 对象缺省时，强引用，sidetable实现，refcnts记录retaincount

copy: 修饰不可变对象，或者为了制造新的对象。

### NSString 用什么关键字？为什么
copy，为了避免数据被污染，比如multiple对它进行赋值，如果不是copy，会导致数据变化。

### 深拷贝和浅拷贝
是否生成新的对象，即retaincount是增加1，还是创建新的对象。

> 若想要自己缩写的对象具备拷贝功能，则需要实现NSCopying协议。
> 
> 如果自定义的对象分为可变与不可变，那么就要同时实现NSCopying与NSMutableCopying协议。
> 
> 复制对象时需决定钱拷贝还是神拷贝，一般情况下应该尽量执行浅拷贝。
> 
> 如果缩写的对象需要深拷贝，那么考虑新增一个专门执行深拷贝的方法。

### NSString使用copy关键字，内部是怎么实现的？string本身会copy吗？
copyWithZone: => 推测内部进行了一次retain

### 使用NSArray 保存weak对象，会有什么问题？
没问题、保存到数组时，会进行一次强引用。

### 有没有用过MRC？怎么用MRC？

### MRC和ARC的区别？
手动实现和编译器实现、修饰符存在差别、对block的处理、编译器会尽可能的保证对象的存活(额外多出来retain、release操作)

### weak修饰的属性释放后会被变成nil，怎么实现的？
sidetable中的weak_table, 配合runloop。

### KVC平时怎么用的？举个例子

### KVC一定能修改readonly的变量吗？
不一定，看是否允许进行 顺序查找 成员变量

系统的比如UIApplication的applicationState无法修改，重写允许顺序查找成员也是崩。

### KVC还有哪些用法？
集合操作，比如就数组中最小值，筛选等操作

### keyPath怎么用的？
参考代码
``` C
    NSRange       r = [aKey rangeOfString: @"." options: NSLiteralSearch];
    NSString	*key = [aKey substringToIndex: r.location];
    NSString	*path = [aKey substringFromIndex: NSMaxRange(r)];
    [[self valueForKey: key] setValue: anObject forKeyPath: path];
```

### KVO的实现原理？
1、生成新的子类并重写父类的behavior
2、修改子类class指向
3、重写keypath对应的setter方法
4、注册

### KVO使用时要注意什么？
次数不匹配，比如重复注册，多次移除

### KVO的观察者如果为weak，会有什么影响？
set方法实际执行的是父类的 willchangge, setvalue 以及didchangge方法。
如果为weak，可能导致观察者被释放，而无法监测到值的变更。

### 如何实现多代理？
集合保存，参考观察者模式

### 给一个对象发消息，中间过程是怎样的？
根据isa 查找(缓存，继承链) -> 动态解析(自身方法实现) -> 消息转发(转发、方法签名、invoke) -> 崩溃

NSObject的metaclass的特殊性

### 消息转发的几个阶段

转到其他对象执行(多继承的一种实现方式)、生成方法签名再给一次挽救机会、not recognise

### 设计一个方案，在消息转发的阶段中统一处理掉找不到方法的这种crash
resolveMethod中通过runtime增加方法

### 如何实现高效绘制圆角
图片、UIpath
避免离屏渲染

### 异步绘制过程中，将生成的image赋值给contents的这种方式，会有什么问题？
需要理解UIView与CALayer的关系

对UIView的大部分操作都是通过CALayer来实现的，设置image也是通过给layer.contents赋值来实现的；

iOS要求所有的UI操作都必须在主线程上完成，所以如果在异步绘制完成image，就需要切换到主线程给contents赋值；


### 前公司负责的模块 用的语言 遇到的问题，怎么解决的 对于该项目当前存在的一些未解决的问题，给出一些解决方案
1、block内部之间访问成员变量
2、OC不同模块方法名相同 IQKeyboardKey
3、模块重构

### 个人项目展示 个人项目展示时遇到了crash，面试官给出crashlog，让我分析是什么问题 项目的设计背景 项目中的实现细节

### 是否愿意在MRC环境下进行开发

### 还有什么问题吗
- swift or objective-c、code or storyboard
- 是否有机会扩展技术(比如后端)
- team & company
- how can I fit in
- career growth
- product lifecycle
- interviewers, find a topic
- dissect the app, suggestion


### 参考 
- [源码搜索](https://searchcode.com/)