//
//  RepoTableViewCell.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    private static let placeholder = UIImage(named: "empty")!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.image = RepoTableViewCell.placeholder
        imageView?.sizeToFit()
    }
    
    var imageUrl: NSURL? {
        willSet {
            if let url = newValue {
                imageView?.setImageWithURL(url, placeholder: RepoTableViewCell.placeholder)
            }
        }
    }
    
}