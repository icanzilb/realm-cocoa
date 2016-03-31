//
//  MasterInterfaceController.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/11/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

//
// This controller shows a searcheable list of repos from realm
// and also updates the peristed repos with latest data from github.
//
class MasterInterfaceController: WKInterfaceController {

    var repositories: Results<Repository>?
    var authRefreshToken: NotificationToken?

    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //fetch repos from realm
        loadRepos()
        
        //get latest data from github
        GitHubAPI.getRepos {repos in
            //persist repos, no matter on which thread
            let realm = try! Realm()
            try! realm.write {
                realm.add(repos, update: true)
            }
        }
    }

    override func willActivate() {
        super.willActivate()
        updateUI()
    }
    
    func loadRepos() {
        let realm = try! Realm()
        repositories = realm.objects(Repository)
            .sorted("stars", ascending: false)
        
        //auto update when new repositories
        authRefreshToken = repositories!.addNotificationBlock {[weak self] _, _ in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        if let repositories = repositories {
            table.setNumberOfRows(repositories.count, withRowType: "RepoRowController")
            for (index, repo) in repositories.enumerate() {
                let controller = table.rowControllerAtIndex(index) as! RepoRowController
                
                controller.text.setText(nil)
                if let favorite = repo.favorite {
                    controller.text.setText("\(favorite.symbol)\(repo.name!)")
                } else {
                    controller.text.setText(repo.name)
                }
                controller.detailText.setText("\(repo.stars) ⭐️")
            }
        }
    }
    
    deinit {
        //stop auto-refreshing
        authRefreshToken?.stop()
    }
    
    //MARK: - Segues
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return repositories![rowIndex]
    }
}