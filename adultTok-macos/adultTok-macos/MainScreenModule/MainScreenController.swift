//
//  MainScreenController.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa
import WebKit
import SnapKit

final class MainScreenController: NSViewController {
    enum Constants {
        static let backForwardInsets: NSEdgeInsets = NSEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        static let cornerRadius: CGFloat = 10
        static let pinkColor: NSColor = .init(red: 255/255, green: 51/255, blue: 153/255, alpha: 1)
    }

    @IBOutlet private weak var boxView: NSBox!
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        configureView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = AppPersistentVariables.baseUrl {
                self.webView.load(URLRequest(url: url))
            }
        }
    }

    private func configureView() {
        boxView.fillColor = .windowBackgroundColor
        boxView.cornerRadius = 0

        let backButton = NSButton()
        backButton.makeAdultButton(with: Constants.pinkColor, radius: Constants.cornerRadius)
        backButton.setAccessibilityIdentifier("back_button")
        backButton.title = L10n.backTitle.localize()
        backButton.action = #selector(backPressed)

        let forwardButton = NSButton()
        forwardButton.makeAdultButton(with: Constants.pinkColor, radius: Constants.cornerRadius)
        forwardButton.setAccessibilityIdentifier("forward_button")
        forwardButton.title = L10n.fwTitle.localize()
        forwardButton.action = #selector(forwardPressed)

        let homeButton = NSButton()
        homeButton.makeAdultButton(with: Constants.pinkColor, radius: Constants.cornerRadius)
        homeButton.setAccessibilityIdentifier("home_button")
        homeButton.title = L10n.homeTitle.localize()
        homeButton.action = #selector(homePressed)

        self.setupConstraints(with: backButton, homeButton, forwardButton)

        if webView.backForwardList.backList.isEmpty {
            backButton.isEnabled = false
        }
        if webView.backForwardList.forwardList.isEmpty {
            forwardButton.isEnabled = false
        }
    }

    private func setupConstraints(with buttons: NSButton...) {
        buttons.forEach { button in
            self.boxView.addSubview(button)
            switch button.accessibilityIdentifier() {
            case "home_button":
                button.snp.makeConstraints {
                    $0.width.equalTo(120)
                    $0.centerX.equalTo(self.boxView.snp.centerX)
                    $0.top.equalTo(self.boxView.snp.top).inset(Constants.backForwardInsets.top)
                    $0.bottom.equalTo(self.boxView.snp.bottom).inset(Constants.backForwardInsets.bottom)
                }
            case "forward_button":
                button.snp.makeConstraints {
                    $0.width.equalTo(80)
                    $0.top.equalTo(self.boxView.snp.top).inset(Constants.backForwardInsets.top)
                    $0.right.equalTo(self.boxView.snp.right).inset(Constants.backForwardInsets.right)
                    $0.bottom.equalTo(self.boxView.snp.bottom).inset(Constants.backForwardInsets.bottom)
                }
            case "back_button":
                button.snp.makeConstraints {
                    $0.width.equalTo(80)
                    $0.top.equalTo(self.boxView.snp.top).inset(Constants.backForwardInsets.top)
                    $0.left.equalTo(self.boxView.snp.left).inset(Constants.backForwardInsets.left)
                    $0.bottom.equalTo(self.boxView.snp.bottom).inset(Constants.backForwardInsets.bottom)
                }
            default:
                break
            }
        }
    }

    @objc private func backPressed() {
        guard
            let backButton = self.boxView.subviews.last?.subviews.first(where: { $0.accessibilityIdentifier() == "back_button" })
        else { return }
        if (backButton as? NSButton)?.isEnabled == true {
            webView.goBack()
        }
    }

    @objc private func forwardPressed() {
        guard
            let forwardButton = self.boxView.subviews.last?.subviews.first(where: { $0.accessibilityIdentifier() == "forward_button" })
        else { return }
        if (forwardButton as? NSButton)?.isEnabled == true {
            webView.goForward()
        }
    }

    @objc private func homePressed() {
        if let url = AppPersistentVariables.baseUrl {
            self.webView.load(URLRequest(url: url))
        }
    }
}

extension MainScreenController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let host = navigationAction.request.url?.host {
            if host.contains("wellhello.com") {
                decisionHandler(.allow)
                return
            }
        }

        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard
            let backButton = self.boxView.subviews.last?.subviews.first(where: { $0.accessibilityIdentifier() == "back_button" }),
            let forwardButton = self.boxView.subviews.last?.subviews.first(where: { $0.accessibilityIdentifier() == "forward_button" })
        else { return }

        if webView.backForwardList.backList.isEmpty {
            (backButton as? NSButton)?.isEnabled = false
        } else {
            (backButton as? NSButton)?.isEnabled = true
        }

        if webView.backForwardList.forwardList.isEmpty {
            (forwardButton as? NSButton)?.isEnabled = false
        }  else {
            (forwardButton as? NSButton)?.isEnabled = true
        }
    }
}
