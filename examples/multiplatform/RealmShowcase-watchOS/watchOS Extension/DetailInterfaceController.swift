//
//  DetailInterfaceController.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/14/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var name:  WKInterfaceLabel!
    @IBOutlet weak var stars: WKInterfaceLabel!
    @IBOutlet weak var favorited: WKInterfaceSwitch!
    
    private var repo: Repository!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let repo = context as? Repository {
            self.repo = repo
            
            if let url = repo.avatarUrl {
                self.image.setImageWithURL(url, placeholder: UIImage(named: "loading")!)
            }

            name.setText(repo.name)
            stars.setText("\(repo.stars) ⭐️")
            favorited.setOn(repo.favorite != nil)
        }
    }
    
    @IBAction func toggleFavorite(sender: WKInterfaceSwitch) {
        
        let realm = try! Realm()
        if let favorite = repo.favorite {
            try! realm.write {
                realm.delete(favorite)
            }
        } else {
            let favorite = Favorite()
            favorite.repo = repo
            
            try! realm.write {
                realm.add(favorite)
            }
        }
    }
    
}
