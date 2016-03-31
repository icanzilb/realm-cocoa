//
//  ViewController.swift
//  RealmShowcaseOSX
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Cocoa
import RealmSwift

//
// This controller shows a searcheable list of repos from realm
// and also updates the peristed repos with latest data from github.
//
class MasterViewController: NSViewController {

    var repositories: Results<Repository>?
    var authRefreshToken: NotificationToken?
    
    var detailsViewController: RepoDetailViewController!

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsViewController = parentViewController!.childViewControllers.last as! RepoDetailViewController
        
        //fetch repos from realm
        loadRepos()
        
        //get latest data from web
        GitHubAPI.getRepos {repos in
            //persist repos, no matter on which thread
            let realm = try! Realm()
            try! realm.write {
                realm.add(repos, update: true)
            }
        }
    }

    func loadRepos(searchTerm: String = "") {
        let realm = try! Realm()
        repositories = realm.objects(Repository)
            .filter("name contains[c] %@", searchTerm)
            .sorted("stars", ascending: false)
        
        //add auto-refresh block
        authRefreshToken = repositories?.addNotificationBlock {[weak self] _, _ in
            if let vc = self {
                let row = vc.tableView.selectedRow
                vc.tableView.reloadData()
                vc.tableView.selectRowIndexes(NSIndexSet(index: row), byExtendingSelection: false)
            }
        }
    }
    
    deinit {
        //stop auto-refreshing
        authRefreshToken?.stop()
    }
}

// MARK: - Tableview Datasource
extension MasterViewController : NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        guard let repositories = repositories else {
            return 0
        }
        return min(repositories.count, 20)
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let repo = repositories![row]

        let cell = tableView.makeViewWithIdentifier("Cell", owner: nil) as! RepoTableViewCell
        cell.text.stringValue = repo.name ?? ""
        cell.detailText.stringValue = "\(repo.stars) ⭐️"
        cell.imageUrl = repo.avatarUrl
        
        if let favorite = repo.favorite {
            cell.text.stringValue += favorite.symbol
        }
        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        detailsViewController.repo = repositories![row]
        return true
    }
}

// MARK: - Search Field
extension MasterViewController {
    @IBAction func updateSearchResults(sender: NSSearchField) {
        tableView.deselectAll(nil)
        loadRepos(sender.stringValue)
    }
}