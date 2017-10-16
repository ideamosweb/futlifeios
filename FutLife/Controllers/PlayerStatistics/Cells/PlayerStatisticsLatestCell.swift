//
//  PlayerStatisticsLatestCell.swift
//  FutLife
//
//  Created by Rene Alberto Santis Vargas on 15/10/2017.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerStatisticsLatestCell: CustomTableViewCell {

    @IBOutlet weak var wrapperResultsView: UIView!
    let results: [String] = ["V", "D", "V", "V", "D"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpView() {
        var previous: UIView?
        
        for i in 0 ..< 5 {
            if previous != nil {
                let resultView = UIView(frame: CGRect(x: (previous?.frame.maxX)! + 5, y: 8, width: 25, height: 45))
                resultView.layer.cornerRadius = 3
                resultView.backgroundColor = resultViewColor(index: i)
                
                let label = UILabel(frame: CGRect(x: 0, y: 15, width: 25, height: 20))
                label.font = UIFont().bebasFont(size: 20)
                label.textColor = UIColor.white
                label.text = results[i]
                label.textAlignment = .center
                
                resultView.addSubview(label)
                
                previous = resultView
                
            } else {
                let resultView = UIView(frame: CGRect(x: 20, y: 8, width: 25, height: 45))
                resultView.layer.cornerRadius = 3
                resultView.backgroundColor = resultViewColor(index: i)
                
                let label = UILabel(frame: CGRect(x: 0, y: 15, width: 25, height: 20))
                label.font = UIFont().bebasFont(size: 20)
                label.textColor = UIColor.white
                label.text = results[i]
                label.textAlignment = .center
                
                resultView.addSubview(label)
                
                previous = resultView
            }
            
            wrapperResultsView.addSubview(previous!)
        }
    }
    
    func resultViewColor(index: Int) -> UIColor {
        var color: UIColor?
        let result =  results[index]
        switch result {
        case "V":
            color = UIColor().greenDefault()
        default:
            color = UIColor().red()
        }
        
        return color!
    }

}
