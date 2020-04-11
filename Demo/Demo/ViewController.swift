//
//  ViewController.swift
//  Demo
//
//  Created by yrion on 2020/4/11.
//  Copyright © 2020 yrion. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {

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
        
        var webV = WKWebView(frame: self.view.bounds, configuration: configuration)
        webV.uiDelegate = self
        webV.navigationDelegate = self
        return webV
    }()
}

extension ViewController {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}

