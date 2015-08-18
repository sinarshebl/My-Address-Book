//
//  ViewController.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/4/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit
import AddressBook
import RHAddressBook

class ViewController: UITableViewController {
    
    var addressBook: ABAddressBookRef?
    let authorizationStatus = ABAddressBookGetAuthorizationStatus()
    var abArray: [NSArray] = []
    var tempImage = UIImage(named: "avatar.png")
    let rhAddressBook = RHAddressBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch authorizationStatus {
        case .Authorized:
            println("You're Authorized!")
            createAddressBook()
        case .Denied:
            println("Aithorization Denied")
        case .NotDetermined:
            createAddressBook()
                ABAddressBookRequestAccessWithCompletion(nil, { (accepted:Bool, error:CFError!) -> Void in
                    if accepted{
                        println("Authorized!")
                    } else{
                        println("Denied")
                    }
                })
        case .Restricted:
            println("Aithorization Restricted")
        default:
            println("There's been a problem")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createAddressBook() {
        var error: Unmanaged<CFErrorRef>?
        let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
     
        if addressBook == nil {
            println("error")
        }
        
        var personDataArray = rhAddressBook.people()
        var personData = [AnyObject]()

        for pd in personDataArray {
            personData = []
            var name = pd.name as String
            personData.append(name)

            var phoneNums = pd.phoneNumbers
            var contactNumberArray = [AnyObject]()
            for var index:UInt = 0; index < RHMultiValue.count(phoneNums)(); index++ {
                var personPhoneNumbers: AnyObject! = phoneNums!.valueAtIndex(index)
                contactNumberArray.append(personPhoneNumbers)
            }
            personData.append(contactNumberArray)
            
            if pd.hasImage() {
                var image = pd.originalImage()
                personData.append(image)
            } else {
                personData.append(tempImage!)
            }

            abArray.append(personData)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contact"{
            var contactDetails: ContactDetails = segue.destinationViewController as! ContactDetails
            var rowIndex = self.tableView.indexPathForSelectedRow()?.row
            
            contactDetails.contactName = self.abArray[rowIndex!][0] as? String
            
            var abc = self.abArray[rowIndex!][1] as? [String]
            var multiString = join("\n", abc!)
            
            contactDetails.contactPhone = multiString
            println(multiString)
            contactDetails.contactAvatar = self.abArray[rowIndex!][2] as? UIImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abArray.count
    }
 
//    func phone
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContactCell
        
        var phone: String?
        let name = abArray[indexPath.row][0] as! String

        let numbers: NSArray = abArray[indexPath.row][1] as! NSArray
        for number in numbers {
            phone = number as? String
        }
        
        let avatar = abArray[indexPath.row][2] as! UIImage
        
        let model = ContactCellModel(phone: phone!, name: name, image: avatar) {
            println("call: \(name) \(phone!)")
            var url:NSURL = NSURL(string: "tel://\(phone!)")!
            println(url)
            UIApplication.sharedApplication().openURL(url)
        }
        
        cell.configure(model)
        
        return cell
    }
    

}

