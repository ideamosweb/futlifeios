//
//  PlayerInfoViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerInfoViewController: FormViewController {
    @IBOutlet weak var playerTextField: UIView!
    @IBOutlet weak var textFieldImage: UIImageView!
    
    let numberOfFields: Int = 6
    let images: [String] = ["profile.username", "profile.username", "profile.location", "profile.email", "profile.telephone", "profile.birthday"]
    let playerInfo: [String]!
    
    var player: UserModel    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        player = LocalDataManager.user!
        playerInfo = [player.userName, player.name, player.cityName, player.email, player.phone!, ""]
        super.init(nibName: "PlayerInfoViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var previousPlayerView: PlayerTextView?
        var textFields: [TextField] = []
        for index in stride(from: 0, to: numberOfFields, by: 1) {
            if let prevPlayerView = previousPlayerView {
                var nextFrame = prevPlayerView.frame
                nextFrame.origin.y = prevPlayerView.frame.maxY
                
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.frame = nextFrame
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            } else {
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            }
            
            formScrollView.addSubview(previousPlayerView!)
        }
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = textFields
    }
}
