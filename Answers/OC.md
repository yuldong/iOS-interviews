## Objective-C
---

### OC本质
``` C
struct NSObject_IMPL {
    Class isa;
}
```
**基于C/C++的结构体实现**
- 了解内存布局
- 通过c函数验证sizeof、malloc_size
- 内存占用与内存分配

### OC对象

**instance对象** 包含 **isa以及成员变量**
  
**class对象 object_getClass(instance)** 包含 **isa以及instance方法**

**meta-class对象 object_getClass(class)** 包含 **isa以及类方法**


### isa 与 superclass

#### isa
- instance 的 isa指向class
- class 的 isa 指向meta-class
- meta-class 的 isa 指向 基类的meta-class

#### superclass
- class 的 superclass 指向 父类的 class； **如果没有父类，superclass为nil**
- meta-class 的 superclass 指向 父类的 meta-calss； **基类的meta-class 的 superclass 指向 基类的 class**

**总结: instance 里存的是真实值， class, meta-class则是类的描述信息**





