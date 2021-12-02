//
//  MainScreenController.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa
import WebKit

final class MainScreenController: NSViewController {
    @IBOutlet private weak var controlView: NSView!
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        if let url = AppPersistentVariables.baseUrl {
            webView.load(URLRequest(url: url))
        }
    }
}

extension MainScreenController: WKNavigationDelegate {

}

extension MainScreenController: WKUIDelegate {

}
