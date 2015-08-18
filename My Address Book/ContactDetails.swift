//
//  ContactDetails.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/9/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit

class ContactDetails: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = contactName
        phone.text = contactPhone
        phone.numberOfLines = 0
        phone.lineBreakMode = NSLineBreakMode.ByWordWrapping
        phone.sizeToFit()
        avatar.image = contactAvatar
    }
    
    var contactName: String! {
        didSet { name?.text = contactName }
    }
    
    var contactPhone: String! {
        didSet{ phone?.text = contactPhone}
    }
    
    var contactAvatar: UIImage! {
        didSet{ avatar?.image = contactAvatar}
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
