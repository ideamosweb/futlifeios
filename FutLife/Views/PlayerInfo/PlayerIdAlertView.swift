//
//  PlayerIdAlertView.swift
//  FutLife
//
//  Created by Rene Alberto Santis Vargas on 22/10/2017.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

protocol PlayerIdAlertViewProtocol {
    func dismissPlayerIdAlertView()
    func alertError()
    func willRequestConsolePlayerId(consoleId: Int, playerId: String)
}

class PlayerIdAlertView: UIView {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var consoleImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var console: ConsoleModel?
    var delegate: PlayerIdAlertViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    
    func setUpView(console: ConsoleModel) {
        self.console = console
        titleLb.font = UIFont().bebasFont(size: 16)
        titleLb.text = "AGREGUE UN PLAYER ID A LA CONSOLA \(console.name)"
        
        let imageUrl = URL(string: console.avatar)!
        let placeholderImage = UIImage(named: "loading_placeholder")!
        consoleImageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
        
        cancelButton.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 10
        
        contentView.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @IBAction func onCancelButtonTouch(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.dismissPlayerIdAlertView()
        }
    }
    
    @IBAction func onAcceptButtonTouch(_ sender: Any) {
        if let delegate = self.delegate {
            if (textField.text?.characters.count)! > 0 {
                delegate.willRequestConsolePlayerId(consoleId: (console?.id)!, playerId: textField.text!)
            } else {
                delegate.alertError()
            }
        }
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}
