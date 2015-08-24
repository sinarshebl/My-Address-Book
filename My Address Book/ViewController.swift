
import UIKit
import AddressBook
import RHAddressBook

class ViewController: UITableViewController {
    
    var addressBook: ABAddressBookRef?
    let authorizationStatus = ABAddressBookGetAuthorizationStatus()
    var abArray: [NSArray] = []
    var tempImage = UIImage(named: "avatar.png")
    let rhAddressBook = RHAddressBook()
    var database:CBLDatabase?
    var contactLiveQuery: CBLLiveQuery!
    var nameQuery: CBLQuery!
    var importTheContact = ImportAddressBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactLiveQuery = ContactModel.queyContacts().asLiveQuery()
        contactLiveQuery.addObserver(self, forKeyPath: "rows", options: .allZeros, context: nil)
        
        nameQuery = ContactModel.queyContacts()
        
        var error: NSError?
        database = CBLManager.sharedInstance().databaseNamed("contacts", error: &error)!

        var pdArray = rhAddressBook.people()
        var cm = ContactModel(forNewDocumentInDatabase: database!)
        
        switch authorizationStatus {
        case .Authorized:
            println("You're Authorized!")
            importTheContact.importPerson(cm, personDataArray: pdArray)
        case .Denied:
            Actions.showAlert(self, title: "Denied", message: "You've denied authorization")
            println("Authorization Denied")
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(nil, { (accepted:Bool, error:CFError!) -> Void in
                if accepted {
                    println("Authorized!")
                } else {
                    println("Denied")
                }
            })
        case .Restricted:
            println("Authorization Restricted")
        default:
            println("There's been a problem")
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        tableView.reloadData()
    }
    
    func deleteDB() {
        var errorDel: NSError?
        if !self.database!.deleteDatabase(&errorDel) {
            println(errorDel)
        }
        println("DATABASE DELETED")
        self.database = nil
    }
    
//    func addContactWithName(name: String, database: CBLDatabase) -> ContactModel? {
//        
//        let doc = database.createDocument()
//        let contact = ContactModel(forDocument: doc)
//        
//        contact.name = name
//        contact.save(nil)
//        println("printing doc \(contact.document)")
//        println("exists: \(database.existingDocumentWithID(contact.document!.documentID))")
//        
//        return contact
//    }
  
    func nameExists(name: String) -> Bool{
        var myError: NSError?
        
        nameQuery.keys = [name]
        let result: AnyObject? = nameQuery.run(&myError)

        return result?.count > 0
    }

//    func createAddressBook() {
////        var error: Unmanaged<CFErrorRef>?
////        let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
//        
//        var personDataArray = rhAddressBook.people()
//          var contactModel = ContactModel(forNewDocumentInDatabase: database!)
//        for pd in personDataArray {
//            let contactModel = ContactModel(forNewDocumentInDatabase: database!)
//            if !nameExists(pd.name) {
//                contactModel.name = pd.name
//                
//                var phoneNums = pd.phoneNumbers
//                var contactNumberArray = [AnyObject]()
//                for var index:UInt = 0; index < RHMultiValue.count(phoneNums)(); index++ {
//                    var personPhoneNumbers: AnyObject! = phoneNums!.valueAtIndex(index)
//                    contactNumberArray.append(personPhoneNumbers)
//                }
//                contactModel.phones = contactNumberArray as! [String]
//
//                var imageData: NSData
//                if pd.hasImage() {
//                    var image = pd.originalImageData()
//                    contactModel.avatar = image
//                } else {
//                    imageData = UIImagePNGRepresentation(tempImage)
//                    contactModel.avatar = imageData
//                }
//                contactModel.save(nil)
//            }
//        }
//    }
    
    // document of row in query
    
    func contactAtIndex(index: Int) -> ContactModel {
        let contactRow = contactLiveQuery.rows?.rowAtIndex(UInt(index))
        let doc = contactRow?.document

        return ContactModel(forDocument: doc!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contact" {
            var contactDetails: ContactDetails = segue.destinationViewController as! ContactDetails
            var rowIndex = self.tableView.indexPathForSelectedRow()?.row
            
            contactDetails.contactName = contactAtIndex(rowIndex!).name

            var phonesArray = contactAtIndex(rowIndex!).phones
            contactDetails.contactPhones = phonesArray

            let image = UIImage(data: contactAtIndex(rowIndex!).avatar)
            contactDetails.contactAvatar = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // func call
    
    func callPhone(phone: String) {
        let phoneString = phone.stringByReplacingOccurrencesOfString(" ", withString: "")
        var url:NSURL = NSURL(string: "tel://\(phoneString)")!
        UIApplication.sharedApplication().openURL(url)
        Actions.showAlert(self, title: "Calling", message: "tel://\(phoneString)")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(contactLiveQuery?.rows?.count ?? 0)
    }
    

    
    //    func phone
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContactCell
        
        var phone: String?
        let personContact = contactAtIndex(indexPath.row)
        let name = personContact.name
        let image = personContact.avatar
        
        let numbers: NSArray = personContact.phones
        for number in numbers {
            phone = number as? String
        }
        
        let model = ContactCellModel(phone: phone, name: name, image: UIImage(data: image)) {
            println("call: \(name) \(phone)")
            self.callPhone(phone!)
        }
        cell.configure(model)
        
        return cell
    }
    
    // Deleteing Contact 
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let nameToDel = contactAtIndex(indexPath.row).name
            let nameToDelDocID = contactAtIndex(indexPath.row).document?.documentID
            let doc = database?.documentWithID(nameToDelDocID!)
            var error: NSError?
            
            if doc != nil {
                doc?.deleteDocument(&error)
                if error == nil {
                    println("Contact deleted")
                }
            }
        }
    }
}

