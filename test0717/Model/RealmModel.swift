//
//  RealmModel.swift
//  test0717
//
//  Created by imac-1681 on 2024/7/18.
//
import RealmSwift
import Foundation
import UIKit

class MessageBoard: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var Name: String = ""
   @Persisted var Constent: String = ""
   @Persisted var CurrenTime: String = ""
    
    
//    override static func primaryKey() -> String? {
//        return "uuid"
//    }
    
    convenience init(Name: String, Constent: String, CurrenTime: String) {
       self.init()
       self.Name = Name
       self.Constent = Constent
        self.CurrenTime = CurrenTime
        
   }
}

//var MessageArray: [MessageBoard] = []

// Open the local-only default realm
//let realm = try! Realm()



