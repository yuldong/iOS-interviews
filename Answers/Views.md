
## Views
---
### Autolayout
Render Loop、Layout Engine:、Cassowary算法 

frame = f(origin, size)
### UIView & CALayer的区别
delegate

事件响应、动画处理、图像渲染

注意drawRect的性能消耗, 尝试使用响应的Layer来实现绘图操作。

无法避免使用drawRect时，尝试指定绘图区域来提高绘图效率。

### 隐式动画 & 显示动画
隐式动画: 未指定动画类型，仅改变了一个属性，然后Core Animation来决定如何并且何时去做动画

显示动画: 将动画动作显示添加到自定的layer上来实现。

**使用uiview自带的API设置某些属性可以执行动画，而直接调用就不行；UIView 默认情况下禁止了 layer 动画，但是在 animation block 中又重新启用了它们**

### 响应链
UIResponder

hidden、interaction、alpha

事件传递从上到下
```
hitTest:withEvent:
pointInside:withEvent:
```

事件响应从下到上
```
nextResponder
```
响应链：由离用户最近的view向系统传递。
initial view –> super view –> …..–> view controller –> window –> Application –> AppDelegate

传递链：由系统向离用户最近的view传递。
UIKit –> active app's event queue –> window –> root view –>……–>lowest view

### 参考
- [官方视频](https://developer.apple.com/videos/play/wwdc2018/220/)
- [从 Auto Layout 的布局算法谈性能](https://draveness.me/layout-performance)
- [View-Layer 协作](https://objccn.io/issue-12-4/)
- [Using Responders and the Responder Chain to Handle Events](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events?language=objc)
- [iOS核心动画高级课程](https://github.com/qunten/iOS-Core-Animation-Advanced-Techniques)
- [绘图与图片的处理](https://github.com/qunten/iOS-Core-Animation-Advanced-Techniques/blob/master/14-%E5%9B%BE%E5%83%8FIO/%E5%9B%BE%E5%83%8FIO.md)
- [图层的性能](https://github.com/qunten/iOS-Core-Animation-Advanced-Techniques/blob/master/15-%E5%9B%BE%E5%B1%82%E6%80%A7%E8%83%BD/15-%E5%9B%BE%E5%B1%82%E6%80%A7%E8%83%BD.md)
