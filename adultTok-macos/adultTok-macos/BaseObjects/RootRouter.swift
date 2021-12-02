//
//  RootRouter.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa

public final class RootRouter: Router {
    public var controlledViewController: NSViewController? {
        return rootViewController
    }

    public var rootViewController: NSViewController?

    public init() {
        self.rootViewController = openMainScreen()
    }
}

extension RootRouter {
    func openMainScreen() -> NSViewController {
        return MainScreenController.loadFromNib()
    }
}

