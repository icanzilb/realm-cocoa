//
//  DetailViewController.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import UIKit
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class DetailViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var favorited: UISwitch!
    
    var repo: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = repo.name
        
        name.text = repo.name
        if let url = repo.avatarUrl {
            image.setImageWithURL(url)
        }
        favorited.on = repo.favorite != nil
    }
    
    @IBAction func toggleFavorite(sender: UISwitch) {
        
        let realm = try! Realm()
        if sender.on {
            let favorite = Favorite()
            favorite.repo = repo
            
            try! realm.write {
                realm.add(favorite)
            }
        } else {
            guard let favorite = repo.favorite else {
                return
            }
            try! realm.write {
                realm.delete(favorite)
            }
        }
    }
    
}