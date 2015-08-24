
import UIKit

class ContactDetails: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = contactName
        avatar.image = contactAvatar
    }
    
    var contactName: String! {
        didSet { name?.text = contactName }
    }
    
    var contactPhones: [String]?
    
    var contactAvatar: UIImage! {
        didSet{ avatar?.image = contactAvatar}
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "phonesTable" {
            var phoneDetails: ContactPhoneTVC = segue.destinationViewController as! ContactPhoneTVC
            phoneDetails.phones = contactPhones!
        }
    }
}
