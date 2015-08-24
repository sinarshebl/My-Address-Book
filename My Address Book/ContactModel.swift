//
//  ContactModel.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/17/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//


import UIKit

class ContactModel: CBLModel {
    
   @NSManaged var name: String
   @NSManaged var avatar: NSData
   @NSManaged var phones:[String]
    
}

extension ContactModel {
    static var contactsView: CBLView {
        let contactView = CBLManager.sharedInstance().databaseNamed("contacts", error: nil)?.viewNamed("contactsView")
        
        if contactView?.mapBlock == nil {
            contactView?.setMapBlock({ (doc, emit) in
                if let name = doc["name"] as? String {
                    emit(name, nil)
                }
                }, version: "2.1")
        }
        return contactView!
    }
    
    class func queyContacts() -> CBLQuery {
        return contactsView.createQuery()
    }
}