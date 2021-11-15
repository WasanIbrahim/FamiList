//
//  DatabaseManager.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//

import Firebase

struct GroceryItem {
  let ref: DatabaseReference?
  let key: String
  let name: String
  let addedByUser: String
  var completed: Bool

  // MARK: Initialize with Raw Data
  init(name: String, addedByUser: String, completed: Bool, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let addedByUser = value["addedByUser"] as? String,
      let completed = value["completed"] as? Bool
    else {
      return nil
    }

    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }

  // MARK: Convert GroceryItem to AnyObject
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "completed": completed
    ]
  }
}


struct User {
  let uid: String
  let email: String

  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email ?? ""
  }

  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}




//// Firebase (Root)
//{
//  // grocery-list-items
//  "grocery-list-items": {
//    // grocery-list-items/bread
//    "bread": {
//      // grocery-list-items/bread/name
//      "name": "bread",
//      // grocery-list-items/bread/addedByUser
//      "addedByUser": "James"
//    },
//    "banana": {
//      "name": "banana",
//      "addedByUser": "Matthew"
//    },
//  }
//}
