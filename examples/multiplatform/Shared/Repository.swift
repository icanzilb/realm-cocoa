//
//  Repository.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation
import RealmSwift

class Repository: Object {

    //MARK: - Persisted properties
    
    dynamic var id: Int = 0
    dynamic var stars: Int = 0
    dynamic var url: String = ""
    dynamic var avatarUrlString: String = ""
    
    //optional property
    dynamic var name: String?

    //MARK: - Dynamic non-persisted properties
    
    //dynamic property
    var avatarUrl: NSURL? {
        get {
            return NSURL(string: avatarUrlString)
        }
        set {
            avatarUrlString = avatarUrl?.absoluteString ?? ""
        }
    }
    
    //dynamic link from another object (auto-ignored because has only a getter)
    var favorite: Favorite? {
        return linkingObjects(Favorite.self, forProperty: "repo").first
    }
    
    //MARK: - Model meta information
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["avatarUrl"]
    }
}