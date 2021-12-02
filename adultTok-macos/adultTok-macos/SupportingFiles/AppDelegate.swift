//
//  AppDelegate.swift
//  adultTok-macos
//
//  Created by mac on 2.12.21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, RouterDelegate {
    @IBOutlet var window: NSWindow!
    private var rootRouter: RootRouter?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window = NSWindow(contentRect: NSScreen.main?.frame ?? NSRect(),
                               styleMask: .fullScreen,
                               backing: .buffered,
                               defer: false)
        self.rootRouter = RootRouter()
        window?.contentViewController = rootRouter?.rootViewController
        self.window?.makeKey()
    }

    func update(with controller: NSViewController?) {
        self.window?.contentViewController = controller
        self.window?.makeKey()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
