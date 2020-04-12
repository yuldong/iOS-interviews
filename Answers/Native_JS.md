## native 与 js 

---
### WKWebview 与 js
**WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate**
- WKNavigationDelegate 




- WKUIDelegate
  
`遵守该协议，用来实现webpage行为对应的native UI展示`





- WKScriptMessageHandler
  
  `遵守该协议的类提供一个用于接受来自webpage中js执行传递的信息`

  ``` Swift
  /** @abstract Adds a script message handler.
     @param scriptMessageHandler The message handler to add.
     @param name The name of the message handler.
     @discussion Adding a scriptMessageHandler adds a function
     window.webkit.messageHandlers.<name>.postMessage(<messageBody>) for all
     frames.
     */
    open func add(_ scriptMessageHandler: WKScriptMessageHandler, name: String)
  ```

  `通过给WKWebViewConfiguration.userViewcontroller增加不同的‘name’来实现不同的js函数调用`







### Javascriptcore



### 参考
- [WKWebView使用JS与Swift交互](https://tomoya92.github.io/2018/07/05/swift-webview-javascript/)