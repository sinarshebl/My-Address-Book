//
//  My_Address_BookTests.swift
//  My Address BookTests
//
//  Created by Sinar Shebl on 8/4/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit
import XCTest

class My_Address_BookTests: XCTestCase {
    

    
    var db: CBLDatabase!
    
    override func setUp() {
        self.continueAfterFailure = false
        super.setUp()
        var error: NSError?
        db = CBLManager.sharedInstance().databaseNamed("database_test", error: &error)
        println("error \(error)")
    }
    
    override func tearDown() {
        db.deleteDatabase(nil)
        super.tearDown()
    }
    
//    func testThatNameIsSetCorrectly() {
//        let vc = ViewController()
//        
//        let name = "name"
//        let contact = vc.addContactWithName(name, database: db)
//        
//        XCTAssertEqual(contact!.name, name, "Expected equal names")
//        XCTAssertNotNil(contact!.document!.documentID, "Document didn't take an ID")
//        let savedDoc = db.existingDocumentWithID(contact!.document!.documentID)
//        XCTAssertNotNil(savedDoc, "Nothing was saved in the database")
//        let savedContact = ContactModel(forDocument: savedDoc!)
//        
//        XCTAssertEqual(savedContact.name, name, "Expected equal names")
//    
//        
//        let name2 = "sinar"
//        let contact2 = vc.addContactWithName(name2, database: db)
//        
//        XCTAssertEqual(contact2!.name, name2, "Expected equal names")
//        
//        let savedDoc2 = db.existingDocumentWithID(contact2!.document!.documentID)!
//        let savedContact2 = ContactModel(forDocument: savedDoc2)
//        
//        XCTAssertEqual(savedContact2.name, name2, "Expected equal names")
//
//    }
    
    func testDeleteDatabase() {
        let vc = ViewController()
        
    
    }
    
}
