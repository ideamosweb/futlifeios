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
    var datePicker: UIDatePicker?
    
    let numberOfFields: Int = 6
    let images: [String] = ["profile.username", "profile.username", "profile.location", "profile.email", "profile.telephone", "profile.birthday"]
    let descTextFields: [String] = ["username", "name", "ubication", "email", "telephone", "birthdate"]
    let playerInfo: [String]!
    
    var player: UserModel
    var textFields: [TextField] = []
    var dateTextField: TextField?
    var formScrollViewDelegate: FormScrollViewProtocol?
    
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
        
        if let formScrollViewDelegate = formScrollViewDelegate {
            formScrollView = formScrollViewDelegate.getFormScrollView()
        }
        
        var previousPlayerView: PlayerTextView?
        for index in stride(from: 0, to: numberOfFields, by: 1) {
            if let prevPlayerView = previousPlayerView {
                var nextFrame = prevPlayerView.frame
                nextFrame.origin.y = prevPlayerView.frame.maxY
                
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.frame = nextFrame
                playerTextView?.playerTextField.delegate = self
                playerTextView?.playerTextField.tag = index
                if index == 2 {
                    playerTextView?.playerTextField.isAutoCompleted = true
                    playerTextView?.playerTextField.autocorrectionType = .no
                }
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            } else {
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.playerTextField.delegate = self
                playerTextView?.playerTextField.tag = index
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            }
            
            view.addSubview(previousPlayerView!)
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
        
        view.addSubview(cancelButton)
        view.addSubview(acceptButton)
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = textFields
    }    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // This fix a bug when hide keyboard scrollview contentInsets changes
        let edgeInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        formScrollView.contentInset = edgeInsets
    }
    
    func onAcceptButtonTouch() {
        let user: UserModel? = LocalDataManager.user!
        if user != nil {
            var params: Parameters = [:]
            for index in stride(from: 0, to: textFields.count, by: 1) {
                let textField: TextField = textFields[index]
                if textField.tag == 2 {
                    if let city = textField.citySelected {
                        params[descTextFields[index]] = city.countryId
                    }
                } else {
                    params[descTextFields[index]] = textField.text
                }
            }
            
            weak var weakSelf = self
            ApiManager.updateUserInfo(userId: (user?.id)!, updateInfo: params, completion: { (errorModel) in
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        strongSelf.presentAlert(title: "¡Felicitaciones!", message: "Jugador actualizado con exito", style: alertStyle.formError, completion: nil)
                    } else {
                        strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError, completion: nil)
                    }
                }
            })
        }
    }
    
    func configDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateTextField?.text = dateFormatter.string(from: sender.date)
    }
}

extension PlayerInfoViewController: UITextViewDelegate {
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard (inputsFormManager.inputFields?.contains(textField as! TextField))! else {
            return false
        }
        
        let txtFld: TextField = (textField as? TextField)!
        if txtFld.tag == 2 {
            let keyWord = (txtFld.text! != "") ? txtFld.text! : string
            ApiManager.getCities(keyword: keyWord, completion: { (errorModel, cities) in
                if cities.count > 0 && string != "" {
                    txtFld.cities = cities
                } else {
                    txtFld.hideAutoCompleteTable()                    
                }
            })
        }
        
        return true
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // In case the input field is not within the form, we don't want to let the user edit it.
        // Example: when the field is hidden.
        // Let the input field manager know what text field is the one with focus.
        inputsFormManager.currentInputField = textField
        return (inputsFormManager.inputFields?.contains(textField as! TextField))!
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        // Let the input field manager know what text field is the one with focus.
        inputsFormManager.currentInputField = textField
        
        if textField.tag == 5 {
            dateTextField = textField as? TextField
            configDatePicker()
            textField.inputView = datePicker
            datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        }
    }
}
