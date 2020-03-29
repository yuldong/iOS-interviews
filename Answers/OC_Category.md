### Category
---

#### 底层结构
``` C
struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
};
```

#### category如何被加载的，两个category的同名方法的加载顺序
- _objc_init、map_images、map_images_nolock、_read_images、remethodizeClass(Class cls)
  
``` C
attachCategories(Class cls, category_list *cats, bool flush_caches);

void attachLists(List* const * addedLists, uint32_t addedCount);

void	*memcpy(void *__dst, const void *__src, size_t __n);

void	*memmove(void *__dst, const void *__src, size_t __len);
```
  
通过runtime加载某个类的所有category信息，将信息进行**区分(属性、方法、协议)合并**到不同的数组中，后参与编译的category信息放在数组前面，再将合并后的分类信息合并到类原来数据的前面。

### 两个category的load方法的加载顺序
category 中的load都会执行，执行顺序可以在 compile source中调整。

category 中的同名方法会同时被保存到 class_rw_t 中

#### category & extension区别，能给NSObject添加Extension吗，结果如何
category是runtime动态添加到类中，extension在编译时已经绑定到所属类

#### 参考
- [Objective-C Category 的实现原理](http://blog.leichunfeng.com/blog/2015/05/18/objective-c-category-implementation-principle/)