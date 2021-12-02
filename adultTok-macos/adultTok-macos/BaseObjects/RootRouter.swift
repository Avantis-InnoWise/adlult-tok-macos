//
//  RootRouter.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa

public protocol RouterDelegate: AnyObject {
    func update(with controller: NSViewController?)
}

public final class RootRouter: Router {
    public var controlledViewController: NSViewController? {
        return rootViewController
    }

    private(set) var rootViewController: NSViewController? {
        didSet {
            delegate?.update(with: rootViewController)
        }
    }

    weak var delegate: RouterDelegate?

    public init() {
        self.openMainScreen()
    }
}

extension RootRouter {
    func openMainScreen() {
        let controller = MainScreenController.loadFromNib()
        let navigationController = NavigationController(rootViewController: controller)
        navigationController.view.layer?.backgroundColor = .clear
        navigationController.viewControllers = [controller]
        rootViewController = navigationController
    }
}

