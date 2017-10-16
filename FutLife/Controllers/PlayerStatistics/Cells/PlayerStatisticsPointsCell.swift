//
//  PlayerStatisticsPointsCell.swift
//  FutLife
//
//  Created by Rene Alberto Santis Vargas on 15/10/2017.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerStatisticsPointsCell: CustomTableViewCell {
    @IBOutlet weak var gamesPlayedLb: UILabel!
    @IBOutlet weak var gamesWonLb: UILabel!
    @IBOutlet weak var gamesLoseLb: UILabel!
    @IBOutlet weak var goalsInFavor: UILabel!
    @IBOutlet weak var goalsAgainst: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUpView() {
        gamesPlayedLb.text = "5"
        gamesWonLb.text = "3"
        gamesLoseLb.text = "2"
        goalsInFavor.text = "7"
        goalsAgainst.text = "4"
    }
}
