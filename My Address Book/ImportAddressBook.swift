
import UIKit
import AddressBook
import RHAddressBook

class ImportAddressBook: NSObject {
    let db = CBLManager.sharedInstance().databaseNamed("contacts", error: nil)

    var tempImage = UIImage(named: "avatar.png")
    var nameQuery: CBLQuery!
}

extension ImportAddressBook {
    func nameExists(name: String) -> Bool{
        var myError: NSError?
        nameQuery = ContactModel.queyContacts()
        nameQuery.keys = [name]
        let result: AnyObject? = nameQuery.run(&myError)
        
        return result?.count > 0
    }
}

extension ImportAddressBook {
    func importPhoneNumbers(phoneNumbers: RHMultiValue) -> [AnyObject] {
        var contactNumberArray = [AnyObject]()
        for var index:UInt = 0; index < RHMultiValue.count(phoneNumbers)(); index++ {
            var personPhoneNumbers: AnyObject! = phoneNumbers.valueAtIndex(index)
            contactNumberArray.append(personPhoneNumbers)
        }
        return contactNumberArray
    }

}

extension ImportAddressBook {
    func importPerson(contactModel: ContactModel, personDataArray: [AnyObject]!) {
        for person in personDataArray {
            if !nameExists(person.name) {
                contactModel.name = person.name
                
                var phoneNums = person.phoneNumbers
                contactModel.phones = importPhoneNumbers(phoneNums) as! [String]
                
                var imageData: NSData
                if person.hasImage() {
                    var image = person.originalImageData()
                    contactModel.avatar = image
                } else {
                    imageData = UIImagePNGRepresentation(tempImage)
                    contactModel.avatar = imageData
                }
                contactModel.save(nil)
            }
        }
    }

}