//
//  FormViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/14/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class FormViewController: ViewController {
    // The ScrollView for form View controller, it's needs to link in
    // interface builder or link programatically
     @IBOutlet var formScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Register observer keyboard notifications
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        let keyboardWillShow = Notification.Name("UIKeyboardWillShow")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name: keyboardWillShow, object: nil)
        
        let keyboardWillHide = Notification.Name("UIKeyboardWillHide")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: keyboardWillHide, object: nil)
    }
    
    deinit {
        // Remove observer keyboard notifications
        unregisterForKeyboardNotifications()
    }
    
    func unregisterForKeyboardNotifications() {
        let keyboardWillShow = Notification.Name("UIKeyboardWillShow")
        NotificationCenter.default.removeObserver(self, name: keyboardWillShow, object: nil)
        
        let keyboardWillHide = Notification.Name("UIKeyboardWillHide")
        NotificationCenter.default.removeObserver(self, name: keyboardWillHide, object: nil)
    }
    
    func keyboardWillBeShown(notification: NSNotification) {
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
    }
}
