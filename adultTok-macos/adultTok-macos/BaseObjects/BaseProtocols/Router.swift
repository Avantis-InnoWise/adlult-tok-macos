//
//  Router.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Foundation
import Cocoa

public protocol Router {
    var controlledViewController: NSViewController? { get }
}

public extension Router where Self: Navigator {
     var controlledViewController: NSViewController? {
        return navigationController
    }
}

public protocol Navigator {
    var rootViewController: NSViewController? { get }
    var initialViewControllers: [NSViewController] { get }
    var navigationController: NavigationController? { get }
}

public extension Navigator {
    var navigationController: NavigationController? {
        return rootViewController?.navigationController
    }

    var initialViewControllers: [NSViewController] {
        return [rootViewController ?? NSViewController()]
    }
}
