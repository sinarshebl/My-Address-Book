//
//  ContactPhone.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/22/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit

class ContactPhone: UITableViewController {
    
//    override func numberOfRowsInSection(section: Int) -> Int {
//        return 1
//    }
    @IBOutlet weak var contactPhonesTable: UITableView!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("phoneNumber", forIndexPath: indexPath) as! ContactCell
        cell.textLabel?.text = "hello"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    
}
