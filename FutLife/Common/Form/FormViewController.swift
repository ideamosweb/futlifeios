//
//  FormViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/14/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class FormViewController: ViewController, UITextFieldDelegate {
    
    // This property manages all the inputs and
    // validate the error messages
    var inputsFormManager = InputFormManager()
    
    // The ScrollView for form View controller, it's needs to link in
    // interface builder or link programatically
     @IBOutlet var formScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Keyboard when lost field focus
        // https://stackoverflow.com/a/27079103
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Register observer keyboard notifications
        registerForKeyboardNotifications()
        
        // Gets the first and last inputs for set the initial scrollView contentSize
        inputsFormManager.firstAndLastInputFieldsClosure { (firstInput, lastInput) in
            let maxY = formScrollView.convert(firstInput.frame, from: firstInput.superview).maxY
            let minY = formScrollView.convert(lastInput.frame, from: lastInput.superview).minY
            
            formScrollView.contentSize = CGSize(width: formScrollView.frame.width, height: minY + maxY)
        }
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
        // In this method the scrollView adjust from the selected field
        // animating the scroll and showing keyboard
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? TimeInterval),
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            formScrollView.contentInset = contentInsets
            formScrollView.scrollIndicatorInsets = contentInsets
            
            let currentInputFrame = inputsFormManager.currentInputField?.frame
            let currentInputSuperView = inputsFormManager.currentInputField?.superview?.superview
            
            // Get the frame of the input field in the scroll view.
            let inputFieldRect = formScrollView.convert(currentInputFrame!, from: currentInputSuperView)
            
            let scrollPointY = inputFieldRect.minY - Constants.kFormTopScrollPadding
            
            if scrollPointY > 0 {
                let scrollPoint = CGPoint(x: 0, y: scrollPointY)
                
                weak var weakSelf = self
                
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve)), animations: {
                    if let strongSelf = weakSelf {
                        strongSelf.formScrollView.setContentOffset(scrollPoint, animated: false)
                    }
                    
                }, completion: { (finished) in
                    // Prevent scrolling when editing the form.
                    if let strongSelf = weakSelf {
                        strongSelf.formScrollView.isScrollEnabled = false
                    }
                })
            }
            
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        // In this method, we restore the scroll view offset.
        if let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? TimeInterval),
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            weak var weakSelf = self
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve)), animations: {
                if let strongSelf = weakSelf {
                    strongSelf.formScrollView.contentInset = UIEdgeInsets.zero
                    strongSelf.formScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                }
            }, completion: { (finished) in
                if let strongSelf = weakSelf {
                    strongSelf.formScrollView.isScrollEnabled = true
                }
            })
            
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextResponder = inputsFormManager.nextInputField
        if nextResponder != nil {
            return (nextResponder?.becomeFirstResponder())!
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // In case the input field is not within the form, we don't want to let the user edit it.
        // Example: when the field is hidden.
        return (inputsFormManager.inputFields?.contains(textField as! TextField))!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Let the input field manager know what text field is the one with focus.
        inputsFormManager.currentInputField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputsFormManager.currentInputField = nil
    }    
}
