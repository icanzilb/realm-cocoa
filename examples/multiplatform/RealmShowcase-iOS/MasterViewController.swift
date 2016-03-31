//
//  MasterViewController.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import UIKit
import RealmSwift

//
// This controller shows a searcheable list of repos from realm
// and also updates the peristed repos with latest data from github.
//
class MasterViewController: UITableViewController {
    
    var repositories: Results<Repository>?
    var authRefreshToken: NotificationToken?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        //stop auto-refreshing
        authRefreshToken?.stop()
    }
    
    func loadRepos(searchTerm: String = "") {
        let realm = try! Realm()
        repositories = realm.objects(Repository)
            .filter("name contains[c] %@", searchTerm)
            .sorted("stars", ascending: false)
        
        //add auto-refresh block
        authRefreshToken = repositories?.addNotificationBlock {[weak self] _, _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let details = segue.destinationViewController as? DetailViewController {
            details.repo = repositories![tableView.indexPathForSelectedRow!.row]
        }
    }
}

// MARK: - Tableview Datasource
extension MasterViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repositories = repositories else {
            return 0
        }
        
        return min(repositories.count, 20)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repo = repositories![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RepoTableViewCell
        cell.textLabel!.text = repo.name!
        cell.detailTextLabel!.text = "\(repo.stars) ⭐️"
        cell.imageUrl = repo.avatarUrl
        
        if let favorite = repo.favorite {
            cell.textLabel!.text! += favorite.symbol
        }
        
        return cell
    }
}

// MARK: - Search Controller
extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        loadRepos(searchController.searchBar.text!)
    }
}

