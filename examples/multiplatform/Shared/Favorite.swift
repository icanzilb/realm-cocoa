//
//  Favorite.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/10/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    
    //persisted property
    dynamic var symbol = "💖"
    
    //link to another object
    dynamic var repo: Repository?
}