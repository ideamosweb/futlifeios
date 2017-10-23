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
    let kProfileCellIdentifier = "PlayerConsolesCell"
    let playerConsoleHeight = 86
    
    var player: UserModel
    var textFields: [TextField] = []
    var dateTextField: TextField?
    var formScrollViewDelegate: FormScrollViewProtocol?
    var consoles: [ConsoleModel]?
    var playerIdTableView: UITableView?
    var playerIdView: PlayerIdAlertView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(consoles: [ConsoleModel]) {
        player = LocalDataManager.user!
        playerInfo = [player.userName, player.name, player.cityName, player.email, player.phone!, ""]
        self.consoles = consoles
        
        super.init(nibName: "PlayerInfoViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let formScrollViewDelegate = formScrollViewDelegate {
            formScrollView = formScrollViewDelegate.getFormScrollView()
        }
        
        tap?.delegate = self
        
        configPlayerIds(preferences: player.preferences!, preferenceId: nil, playerId: nil)
        
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
                
                playerTextView?.playerTextField.isEnabled = false
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            } else {
                let playerTextView = Bundle.main.loadNibNamed("PlayerTextView", owner: self, options: nil)?.first as? PlayerTextView
                playerTextView?.configView(text: playerInfo[index], imageName: images[index])
                playerTextView?.playerTextField.delegate = self
                playerTextView?.playerTextField.tag = index
                playerTextView?.playerTextField.isEnabled = false
                
                textFields.append((playerTextView?.playerTextField)!)
                
                previousPlayerView = playerTextView
            }
            
            view.addSubview(previousPlayerView!)
        }
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = textFields
        
        // Get last playerTextView
        let lastTextfield: PlayerTextView = previousPlayerView!
        
        // config playerIdTableView
        let separator = UIView(frame: CGRect(x: 20, y: lastTextfield.frame.maxY + 10, width: Utils.screenViewFrame().width - 40, height: 1.0))
        separator.backgroundColor = UIColor().lightGray()
        
        playerIdTableView = UITableView(frame: CGRect(x: 0, y: separator.frame.maxY + 10, width: view.bounds.width, height: getPlayerIdTableHeight(consoles: consoles!) + 104))
        playerIdTableView?.delegate = self
        playerIdTableView?.dataSource = self
        playerIdTableView?.separatorStyle = .none
        playerIdTableView?.bounces = false
        playerIdTableView?.isScrollEnabled = false
        playerIdTableView?.isUserInteractionEnabled = true
        
        playerIdTableView?.register(PlayerConsolesCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
        
        // Adjust scrollView contentSize for playerIdTableView
        var scrollContentSize: CGSize = formScrollView.contentSize
        scrollContentSize.height += (playerIdTableView?.bounds.height)! + 104
        formScrollView.contentSize = scrollContentSize
        
        view.addSubview(separator)
        view.addSubview(playerIdTableView!)
        
        let editInfoNoti = Notification.Name(Constants.kDidEditInfoItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(focusFirstTextView), name: editInfoNoti, object: nil)
        
        let cancelInfoNoti = Notification.Name(Constants.kDidCancelInfoItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(disableTextFields), name: cancelInfoNoti, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // This fix a bug when hide keyboard scrollview contentInsets changes
        let edgeInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        formScrollView.contentInset = edgeInsets
    }
    
    deinit {
        let editInfoNoti = Notification.Name(Constants.kDidEditInfoItemNotification)
        NotificationCenter.default.removeObserver(self, name: editInfoNoti, object: nil)
        
        let cancelInfoNoti = Notification.Name(Constants.kDidCancelInfoItemNotification)
        NotificationCenter.default.removeObserver(self, name: cancelInfoNoti, object: nil)
    }
    
    func getPlayerIdTableHeight(consoles: [ConsoleModel]) -> CGFloat {
        var height: CGFloat = CGFloat(playerConsoleHeight)
        for i in 1 ... consoles.count {
            height = height * CGFloat(i)
        }
        
        return height
    }
    
    func focusFirstTextView() {
        if textFields.count > 0 {
            for txtFld in textFields {
                txtFld.isEnabled = true
            }
            
            let textField = textFields.first
            textField?.becomeFirstResponder()
        }
    }
    
    func retriveFieldsValues() -> Parameters {
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
        
        return params
    }
    
    func disableTextFields() {
        if textFields.count > 0 {
            for txtFld in textFields {
                txtFld.isEnabled = false
            }
        }
    }
    
    func configDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        // Min date 19 years before from now
        let now = Date()
        let minDate = now.addingTimeInterval(-(60*60*24*30*12*19))
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = Date()
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateTextField?.text = dateFormatter.string(from: sender.date)
    }
    
    func configPlayerIds(preferences: [PreferencesModel], preferenceId: Int?, playerId: String?) {
        //LocalDataManager.playerIds = nil
        var consoleIds: [String: String] = [:]
        var prefValue: String = ""
        for preference: PreferencesModel in preferences {
            if let prefId = preferenceId {
                if preference.id == prefId {
                    prefValue = playerId!
                } else {
                    prefValue = (LocalDataManager.playerIds?["\(preference.id)"]!)!
                }
            } else {
                if LocalDataManager.playerIds?["\(preference.id)"] == nil {
                    prefValue = "SIN REGISTRAR"
                } else {
                    prefValue = (LocalDataManager.playerIds?["\(preference.id)"]!)!
                }
            }
            
            consoleIds["\(preference.id)"] = prefValue
        }
        
        LocalDataManager.playerIds = consoleIds
    }
    
    func setUplayerIdAlert(console: ConsoleModel) {
        playerIdView = Bundle.main.loadNibNamed("PlayerIdAlertView", owner: self, options: nil)?.first as? PlayerIdAlertView
        playerIdView?.setUpView(console: console)
        playerIdView?.delegate = self
        playerIdView?.layoutIfNeeded()
        playerIdView?.layoutSubviews()
        
        parent?.view.addSubview(playerIdView!)
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
                if let cities = cities {
                    if cities.count > 0 && string != "" {
                        txtFld.cities = cities
                    } else {
                        txtFld.hideAutoCompleteTable()
                    }
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

extension PlayerInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consoles?[indexPath.row]
        
        setUplayerIdAlert(console: console!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        
        return CGFloat(playerConsoleHeight)
    }
}

extension PlayerInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return (consoles?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            let playerCell = UITableViewCell(style: .default, reuseIdentifier: "playerCell")
            playerCell.textLabel?.text = "Mis PLAYER ID"
            playerCell.textLabel?.font = UIFont().bebasFont(size: 17)
            playerCell.isUserInteractionEnabled = false
            
            cell = playerCell
        } else {
            let playerConsoleCell: PlayerConsolesCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier, for: indexPath) as! PlayerConsolesCell
            let console = consoles?[indexPath.row]
            
            if let playerId = LocalDataManager.playerIds {
                let preference: PreferencesModel = (player.preferences?[indexPath.row])!
                playerConsoleCell.setUpConsole(name: (console?.avatar)!, gameName: (console?.name)!, playerId: playerId["\(preference.id)"]!)
            }
            
            playerConsoleCell.isUserInteractionEnabled = true
            
            cell = playerConsoleCell
        }
        
        return cell
    }
}

extension PlayerInfoViewController: PlayerIdAlertViewProtocol {
    func alertError() {
        self.presentAlert(title: "Error", message: "Debes agregar un Player Id primero", style: alertStyle.formError, completion: nil)
    }    
    
    func dismissPlayerIdAlertView() {
        playerIdTableView?.reloadData()
        playerIdView?.removeFromSuperview()
    }
    
    func willRequestConsolePlayerId(consoleId: Int, playerId: String) {
        var preferenceId: Int = 0
        weak var weakSelf = self
        AppDelegate.showPKHUD()
        for preference: PreferencesModel in player.preferences! {
            if preference.consoleId == "\(consoleId)" {
                preferenceId = preference.id
            }
        }
        
        ApiManager.consolePlayerId(preferenceId: preferenceId) { (errorModel) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    strongSelf.presentAlert(title: "Felicidades!", message: "Tu nuevo player id esta listo.", style: alertStyle.formError, completion: { (action) in
                        if action {
                            //LocalDataManager.playerIds = nil
                            strongSelf.configPlayerIds(preferences: self.player.preferences!, preferenceId: preferenceId, playerId: playerId)
                            strongSelf.dismissPlayerIdAlertView()
                        }
                    })
                } else {
                    strongSelf.presentAlert(title: "Error", message: "Error desconocido, intente mas tarde", style: alertStyle.formError, completion: nil)
                }
            }
        }
    }
}

extension PlayerInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.frame.height == 86 {
            return false
        }
        
        return true
    }
}
