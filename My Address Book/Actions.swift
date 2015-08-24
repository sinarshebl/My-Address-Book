//
//  Actions.swift
//  My Address Book
//
//  Created by Sinar Shebl on 8/20/15.
//  Copyright (c) 2015 Sinar Shebl. All rights reserved.
//

import UIKit

public class Actions: NSObject {
    
}

extension Actions {
    class func showAlertAndDismiss(delegate: UIViewController, title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        delegate.presentViewController(alert, animated: true, completion: nil)
    }
}

extension Actions {
    class func showAlert(delegate: UIViewController, title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        delegate.presentViewController(alert, animated: true, completion: nil)
    }
}