//
//  NSButton.swift
//  adultTok-macos
//
//  Created by mac on 6.12.21.
//

import Cocoa

extension NSButton {
    func makeAdultButton(with color: NSColor, radius: CGFloat) {
        self.bezelStyle = .texturedSquare
        self.wantsLayer = true
        self.isBordered = false
        self.layer?.backgroundColor = color.cgColor
        self.layer?.masksToBounds = true
        self.layer?.cornerRadius = radius
    }
}
