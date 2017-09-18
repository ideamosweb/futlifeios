//
//  PlayerStatisticsViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerStatisticsViewController: ViewController {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "PlayerStatisticsViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 20, y: 30, width: Utils.screenViewFrame().width - 40, height: 22))
        label.font = UIFont().bebasFont(size: 20)
        label.text = "Funcionalidad en desarrollo"
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        view.addSubview(label)
    }
}
