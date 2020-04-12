//
//  WKWebViewController.swift
//  Demo
//
//  Created by yrion on 2020/4/11.
//  Copyright © 2020 yrion. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let html = try! String(contentsOfFile: Bundle.main.path(forResource: "index", ofType: "html")!, encoding: .utf8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webV)
        webV.loadHTMLString(html, baseURL: nil)
    }
    
    lazy var webV: WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        configuration.userContentController.add(self, name: "AppModel2")
        
        var webV = WKWebView(frame: self.view.bounds, configuration: configuration)
        webV.uiDelegate = self
        webV.navigationDelegate = self
        return webV
    }()
}

extension WKWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
    }
}

