//
//  ViewController.swift
//  RealmShowcase-tvOS
//
//  Created by Marin Todorov on 3/11/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import UIKit
import RealmSwift

//
// This controller shows a searcheable list of repos from realm
// and also updates the peristed repos with latest data from github.
//
class MasterViewController: UICollectionViewController {

    var repositories: Results<Repository>?
    var authRefreshToken: NotificationToken?

    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.addTarget(self, action: #selector(MasterViewController.updateSearchResults(_:)), forControlEvents: .EditingChanged)
        
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
            self?.collectionView!.reloadData()
        }
    }

    //MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let details = segue.destinationViewController as? DetailViewController {
            details.repo = repositories![collectionView!.indexPathsForSelectedItems()!.first!.row]
        }
    }
}

//MARK: - Collection view
extension MasterViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let repositories = repositories else {
            return 0
        }
        return min(repositories.count, 20)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let repo = repositories![indexPath.item]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RepoCollectionViewCell
        cell.text.text = repo.name ?? ""
        cell.detailText.text = "\(repo.stars) ⭐️"
        cell.imageUrl = repo.avatarUrl
        
        if let favorite = repo.favorite {
            cell.text.text! += favorite.symbol
        }

        return cell
    }
}

//MARK: - Search Field
extension MasterViewController {
    func updateSearchResults(sender: UITextField) {
        loadRepos(sender.text ?? "")
    }
    
    @IBAction func clearSearchField(sender: UIButton) {
        searchField.text = nil
        loadRepos()
    }
}

//MARK: - tvOS focus handling
extension MasterViewController {
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        UIView.animateWithDuration(0.2) {
            //previous
            if let previousItem = context.previouslyFocusedView as? RepoCollectionViewCell {
                previousItem.imageView.transform = CGAffineTransformIdentity
                previousItem.imageView.layer.borderWidth = 0.0
                previousItem.imageView.layer.cornerRadius = 10.0
            }
            
            //next
            if let nextItem = context.nextFocusedView as? RepoCollectionViewCell {
                nextItem.imageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                nextItem.imageView.layer.borderWidth = 5.0
                nextItem.imageView.layer.cornerRadius = 30.0
            }
        }
    }
}
