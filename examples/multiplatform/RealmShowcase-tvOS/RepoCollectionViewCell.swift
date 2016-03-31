//
//  RepoCollectionViewCell.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/11/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import UIKit

class RepoCollectionViewCell: UICollectionViewCell {
    
    private static let placeholder = UIImage(named: "empty")!
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.borderColor = UIColor.orangeColor().CGColor
        imageView?.image = RepoCollectionViewCell.placeholder
        imageView?.sizeToFit()
    }
    
    var imageUrl: NSURL? {
        willSet {
            if let url = newValue {
                imageView?.setImageWithURL(url, placeholder: RepoCollectionViewCell.placeholder)
            }
        }
    }
}