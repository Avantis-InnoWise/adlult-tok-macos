//
//  NSButton.swift
//  adultTok-macos
//
//  Created by mac on 6.12.21.
//

import Cocoa

extension NSButton {
    func makeAdultButton(with color: NSColor, radius: CGFloat) {
        self.bezelStyle = .rounded
        self.bezelColor = color
        self.alignment = .center
        self.layer?.cornerRadius = radius
    }
}
