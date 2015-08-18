//
//  ContactCell.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/4/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit

typealias CallHandler = () -> ()

protocol ContactCellModelProtocol {
    var phone: String { get }
    var name: String { get }
    var image: UIImage? { get }
    var callHandler: CallHandler { get }
}

struct ContactCellModel: ContactCellModelProtocol {
    let phone: String
    let name: String
    let image: UIImage?
    let callHandler: CallHandler
}

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactAvatar: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    var callHandler: CallHandler?
    
    @IBAction func callAction(sender: AnyObject) {
        callHandler?()
    }
    
}


// MARK: Configuration

extension ContactCell {
    func configure(model: ContactCellModelProtocol) {
        contactPhone.text = model.phone
        contactName.text = model.name
        contactAvatar.image = model.image
        callHandler = model.callHandler
    }
}