//
//  AppDelegate.swift
//  RealmShowcaseOSX
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

}

class ChromelessWindows: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        styleMask = styleMask | NSFullSizeContentViewWindowMask
        titlebarAppearsTransparent = true
    }
}