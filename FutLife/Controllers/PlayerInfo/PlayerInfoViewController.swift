//
//  PlayerInfoViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import Alamofire

class PlayerInfoViewController: FormViewController {
    @IBOutlet weak var playerTextField: UIView!
    @IBOutlet weak var textFieldImage: UIImageView!
    
    let numberOfFields: Int = 6
    let images: [String] = ["profile.username", "profile.username", "profile.location", "profile.email", "profile.telephone", "profile.birthday"]
    let playerInfo: [String]!
    
    var player: UserModel
    var textFields: [TextField] = []
    
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
        for index in stride(from: 0, to: numberOfFields, by: 1) {
            if let prevPlayerView = previousPlayerView {
                var nextFrame = prevPlayerView.frame
                nextFrame.origin.y = prevPlayerView.frame.maxY
                
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.frame = nextFrame
                playerTextView?.playerTextField.delegate = self
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            } else {
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.playerTextField.delegate = self
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            }
            
            formScrollView.addSubview(previousPlayerView!)
        }
        
        let cancelButton = UIButton(frame: CGRect(x: 30, y: (previousPlayerView?.frame.maxY)! + 20, width: (Utils.screenViewFrame().width / 2 - 40), height: 30))
        cancelButton.titleLabel?.font = UIFont().bebasBoldFont(size: 18)
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = UIColor().red()
        cancelButton.layer.cornerRadius = 10
        
        let acceptButton = UIButton(frame: CGRect(x: Utils.screenViewFrame().width - cancelButton.frame.width - 30, y: (previousPlayerView?.frame.maxY)! + 20, width: (Utils.screenViewFrame().width / 2 - 40), height: 30))
        acceptButton.titleLabel?.font = UIFont().bebasBoldFont(size: 18)
        acceptButton.setTitle("Aceptar", for: .normal)
        acceptButton.setTitleColor(UIColor.white, for: .normal)
        acceptButton.backgroundColor = UIColor().greenDefault()
        acceptButton.layer.cornerRadius = 10
        acceptButton.addTarget(self, action: #selector(onAcceptButtonTouch), for: .touchUpInside)
        
        formScrollView.addSubview(cancelButton)
        formScrollView.addSubview(acceptButton)
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = textFields
    }
    
    func onAcceptButtonTouch() {
        let user: UserModel? = LocalDataManager.user!
        if user != nil {
            var params: Parameters = [:]
            for index in stride(from: 0, to: textFields.count, by: 1) {
                let textField: TextField = textFields[index]
                switch index {
                case 0:
                    params["username"] = textField.text
                case 1:
                    params["name"] = textField.text
                case 2:
                    params["ubication"] = textField.text
                case 3:
                    params["email"] = textField.text
                case 4:
                    params["telephone"] = textField.text
                case 5:
                    params["birthdate"] = textField.text
                default:
                    break
                }
                
            }
            
            weak var weakSelf = self
            ApiManager.updateUserInfo(userId: (user?.id)!, updateInfo: params, completion: { (errorModel) in
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        
                        
                    }
                }
            })
        }
    }
}
