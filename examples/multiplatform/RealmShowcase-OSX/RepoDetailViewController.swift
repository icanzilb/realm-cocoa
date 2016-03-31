//
//  DetailViewController.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Cocoa
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class RepoDetailViewController: NSViewController {
    
    @IBOutlet weak var name: NSButton!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var favorited: NSButton!
        
    var repo: Repository! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        view.hidden = false
        title = repo.name
        
        name.title = repo.name ?? ""
        if let url = repo.avatarUrl {
            image.setImageWithURL(url)
        } else {
            image.image = nil
        }
        favorited.state = (repo.favorite != nil) ? NSOnState : NSOffState
    }
    
    @IBAction func toggleFavorite(sender: NSButton) {
        
        let realm = try! Realm()
        if sender.state == NSOnState {
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
    
    @IBAction func openRepo(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: repo.url)!)
    }
}