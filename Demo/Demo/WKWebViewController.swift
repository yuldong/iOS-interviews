//
//  WKWebViewController.swift
//  Demo
//
//  Created by yrion on 2020/4/11.
//  Copyright © 2020 yrion. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {

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

extension WKWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertVC = UIAlertController(title: "Tips", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            completionHandler()
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            completionHandler(true)
        }
        alertVC.addAction(action)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            completionHandler(false)
        }
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertVC = UIAlertController(title: "Input", message: prompt, preferredStyle: .alert)
        alertVC.addTextField { (text) in
            text.placeholder = defaultText
        }
        let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            completionHandler(alertVC.textFields?[0].text)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

