## Objective-C
---

#### OC本质
``` C
struct NSObject_IMPL {
    Class isa;
}
```
**基于C/C++的结构体实现**
- 了解内存布局
- 通过c函数验证sizeof、malloc_size
- 内存占用与内存分配

#### OC对象

**instance对象** 包含 **isa以及成员变量**
  
**class对象 object_getClass(instance)** 包含 **isa以及instance方法**

**meta-class对象 object_getClass(class)** 包含 **isa以及类方法**





