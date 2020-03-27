### 关联对象
---
#### 关联对象的应用？系统如何实现关联对象的？关联对象的如何进行内存管理的？关联对象如何实现weak属性
**用途**

1、模拟添加变量
2、为KVO创建一个关联者

**原理**

AssociationsManager, AssociationsHashMap, ObjectAssociationMap, ObjcAssociation
ObjectAssociationMap = AssociationsHashMap.find(object);
ObjcAssociation = ObjectAssociationMap.find(key);

``` C
class AssociationsManager {
    // associative references: object pointer -> PtrPtrHashMap.
    static AssociationsHashMap *_map;
}
class ObjcAssociation {
    uintptr_t _policy;
    id _value;
}
```

**内存管理**
``` C

void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
id objc_getAssociatedObject(id object, const void *key);

typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object. 
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied. 
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
                                            *   The association is made atomically. */
    OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
                                            *   The association is made atomically. */
};
```