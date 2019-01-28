//
//  ToDoListItem.swift
//  Realm ToDoList
//
//  Created by MauriRios on 1/15/19.
//  Copyright © 2019 Pencil. All rights reserved.
//

import Foundation
import RealmSwift

class ProductItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
