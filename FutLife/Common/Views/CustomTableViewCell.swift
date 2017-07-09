//
//  CustomTableViewCell.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib(_ cellIdentifier: String) -> UINib {
        return UINib(nibName: cellIdentifier, bundle: Bundle.main)
    }
    
    static func cellIdentifier() -> String {
        return NSStringFromClass(self)
    }
}
