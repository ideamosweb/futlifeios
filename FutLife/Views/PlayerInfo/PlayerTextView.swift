//
//  PlayerTextView.swift
//  FutLife
//
//  Created by Rene Santis on 9/12/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerTextView: UIView {    
    
    @IBOutlet weak var playerTextField: TextField!
    @IBOutlet weak var textFieldImage: UIImageView!
    @IBInspectable var nibName:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(text: String, imageName: String) {
        playerTextField.font = UIFont().bebasFont(size: 18)
        playerTextField.text = text
        textFieldImage.image = UIImage(named: imageName)
    }

}
