
import UIKit

class ContactPhoneTVC: UITableViewController {

    var phones = [String]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "phoneCell")
        cell.textLabel?.text = phones[indexPath.row]
        return cell
    }
}
