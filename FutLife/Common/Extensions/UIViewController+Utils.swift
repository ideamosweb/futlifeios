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
    func presentAlert(title: String, message: String, style: alertStyle, completion: ((Bool) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        var actions: [UIAlertAction] = []
        switch style {
        case .formError:
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            actions.append(okAction)
        case .cancel:
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                completion!(true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                completion!(false)
            })
            
            actions.append(okAction)
            actions.append(cancelAction)
        }
        
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
