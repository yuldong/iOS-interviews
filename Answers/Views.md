
## Views
---
### Autolayout
Render Loop、Layout Engine:、Cassowary算法 

frame = f(origin, size)
### UIView & CALayer的区别
delegate

事件响应、动画处理、图像渲染

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
- [iOS核心动画高级课程](https://zsisme.gitbooks.io/ios-/)

