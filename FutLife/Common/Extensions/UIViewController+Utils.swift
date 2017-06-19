//
//  UIViewController+Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import UIKit

enum alertStyle {
    case formError
    case cancel
}


extension UIViewController {
    func presentAlert(title: String, message: String, style: alertStyle) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        var actions: [UIAlertAction] = []
        switch style {
        case .formError:
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            actions.append(okAction)
        case .cancel:
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            
            actions.append(okAction)
            actions.append(cancelAction)
        }
        
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
