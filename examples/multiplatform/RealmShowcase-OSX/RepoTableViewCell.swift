//
//  RepoTableViewCell.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Cocoa

class RepoTableViewCell: NSTableCellView {

    @IBOutlet var text: NSTextField!
    @IBOutlet var detailText: NSTextField!
    @IBOutlet var image: NSImageView!
    
    private static let placeholder = NSImage(named: "empty")!
    
    var imageUrl: NSURL? {
        willSet {
            if let url = newValue {
                image.setImageWithURL(url, placeholder: RepoTableViewCell.placeholder)
            }
        }
    }

}