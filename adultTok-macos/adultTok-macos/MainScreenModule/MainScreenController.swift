//
//  MainScreenController.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa
import WebKit

final class MainScreenController: NSViewController {
    @IBOutlet private weak var boxView: NSBox!
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        configureView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let url = AppPersistentVariables.baseUrl {
                self.webView.load(URLRequest(url: url))
            }
        }
    }

    func configureView() {
        boxView.fillColor = .yellow
    }
}

extension MainScreenController: WKNavigationDelegate {

}

extension MainScreenController: WKUIDelegate {

}
