//
//  NavigationController.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import AppKit
import Cocoa

public class NavigationController: NSViewController {
    public var viewControllers: [NSViewController] = []

    open override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
    }

    public init(rootViewController: NSViewController) {
        super.init(nibName: nil, bundle: nil)
        pushViewController(rootViewController, animated: false)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

extension NavigationController {
    public var topViewController: NSViewController? {
        return viewControllers.last
    }

    public func pushViewControllerAnimated(_ viewController: NSViewController) {
        pushViewController(viewController, animated: true)
    }

    public func pushViewController(_ viewController: NSViewController, animated: Bool) {
        viewController.navigationController = self
        viewController.view.wantsLayer = true
        if animated, let oldVC = topViewController {
            let endFrame = oldVC.view.frame
            let startFrame = endFrame.offsetBy(dx: endFrame.width, dy: 0)
            viewController.view.frame = startFrame
            viewController.view.alphaValue = 0.85
            viewControllers.append(viewController)
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                context.allowsImplicitAnimation = true
                context.timingFunction = .init(name: .easeOut)
                viewController.view.animator().frame = endFrame
                viewController.view.animator().alphaValue = 1
                oldVC.view.animator().alphaValue = 0.25
            }) {
                oldVC.view.alphaValue = 1
                oldVC.view.removeFromSuperview()
            }
        } else {
            viewControllers.append(viewController)
        }
    }
}

extension NSViewController {
    private struct OBJCAssociationKey {
        static var navigationController = "adulttok.navigationController"
    }

    public var navigationController: NavigationController? {
        get {
            return ObjCAssociation.value(from: self, forKey: &OBJCAssociationKey.navigationController)
        } set {
            ObjCAssociation.setAssign(value: newValue, to: self, forKey: &OBJCAssociationKey.navigationController)
        }
    }
}

struct ObjCAssociation {
    static func value<T>(from object: AnyObject, forKey key: UnsafeRawPointer) -> T? {
       return objc_getAssociatedObject(object, key) as? T
    }

    static func setAssign<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
       objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
}
