
import UIKit

class AddContact: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
    let contactsDB = CBLManager.sharedInstance().databaseNamed("contacts", error: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.delegate = self
        self.phoneLabel.delegate = self
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        pickedImage.image = image
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        var imageToPost = UIImagePickerController()
        imageToPost.delegate = self
        imageToPost.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imageToPost.allowsEditing = true
        self.presentViewController(imageToPost, animated: true, completion: nil)
    }
    
    @IBAction func addNewContact(sender: AnyObject) {
        let contactModel = ContactModel(forNewDocumentInDatabase: contactsDB!)
        if nameLabel.text == "" {
            Actions.showAlert(self, title: "Failed ", message: "Please enter a name")
        } else if phoneLabel.text == "" {
            Actions.showAlert(self, title: "Failed ", message: "Please enter a phone number")
        } else {
            contactModel.name = nameLabel.text
            contactModel.phones = [phoneLabel.text]
            contactModel.avatar = UIImagePNGRepresentation(pickedImage.image)
            contactModel.save(nil)
            self.navigationController?.popViewControllerAnimated(true)
            Actions.showAlertAndDismiss(self, title: "Successfuly ", message: "Contact has been added")
        }
    }
    
    // controlling the keyboard
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
