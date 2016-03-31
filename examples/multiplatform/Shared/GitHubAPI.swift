//
//  GitHubAPI.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation

//
// A simple GitHub API client
//
class GitHubAPI {
    
    private static let reposUrl = NSURL(string: "https://api.github.com/search/repositories?q=language:swift")!

    // gets a list of repo json items from github and converts them to objects
    static func getRepos(completion: ([Repository])->Void) {
        
        let request = NSURLRequest(URL: reposUrl)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error in
            do {
                if let error = error {
                    throw error
                }
                
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                let items = response["items"] as! [[String: AnyObject]]
                
                //convert json dictionaries to `Repository` objects
                let repos = items.map {item -> Repository in

                    //create objects like usual
                    let repo = Repository()
                    repo.id = item["id"] as! Int
                    repo.name = item["name"] as? String
                    repo.stars = item["stargazers_count"] as! Int
                    repo.url = item["html_url"] as! String
                    repo.avatarUrlString = (item["owner"] as! [String: AnyObject])["avatar_url"] as? String ?? ""
                    return repo
                }
                
                completion(repos)
                
            } catch (let error as NSError) {
                print("Error: " + error.localizedDescription)
                completion([])
            }
            
        }.resume()
    }
    
}