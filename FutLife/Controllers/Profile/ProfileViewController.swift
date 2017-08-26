//
//  ProfileViewController.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class ProfileViewController: ViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var consolesButton: UIButton!
    @IBOutlet weak var gamesButton: UIButton!
    @IBOutlet weak var tabSelectedSeparatorView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var completedRegisterButton: UIButton!
    
    var consolesTableView: UITableView?
    var gamesTableView: UITableView?
    var user: UserModel?
    
    var games = [GameModel]()
    var gamesStr = [Any]()
    var consoles = [ConsoleModel]()
    
    var isConfirmButton: Bool
    var isNavBar: Bool
    var profileCompleted: () -> Void
    
    let kTableViewHeight: CGFloat = 480.0
    let kProfileCellHeight: CGFloat = 54.0
    let kProfileConsoleCellHeight: CGFloat = 22.0
    let kProfileCellIdentifier = "ProfileCell"
    var selectedCellIndexPath: IndexPath?
    let kProfileCellConsolesHeight: CGFloat = 31.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, confirmButton: Bool, profileCompleted: @escaping () -> Void) {
        self.profileCompleted = profileCompleted
        isConfirmButton = confirmButton
        isNavBar = navBar
        super.init(nibName: "ProfileViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        games = LocalDataManager.gamesSelected!
        
        for game: GameModel in games {
            let gamesObj = [
                "game_id": "\(game.id)",
                "year": "\(game.year)",
                "name": "\(game.name)",
                "avatar": "\(game.avatar)",
                "thumbnail": "\(game.thumbnail)",
                "active": "\(game.active)",
                "created_at": "\(game.createdAt)",
                "updated_at": "\(game.updatedAt)"
            ]
            
            gamesStr.append(gamesObj)
        }
        consoles = LocalDataManager.consolesSelected!
        user = LocalDataManager.user!
        if user != nil {
            nameLabel.text = user?.name
            userNameLabel.text = user?.userName
        }
        
        navigationItem.title = isConfirmButton ? "Resumen" : "Perfil"
        completedRegisterButton.isHidden = !isConfirmButton       
        
        avatarImageView.circularView(borderColor: UIColor().greenDefault())
        
        configTablesAndScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar(show: isNavBar)
        
        if let avatar: UIImage = LocalDataManager.avatar {
            avatarImageView.image = avatar
        }
        
        consolesButton.setTitleColor(UIColor.white, for: .normal)
        gamesButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubview(toFront: completedRegisterButton)        
    }
    
    private func configTablesAndScrollView() {
        let consolesTableViewFrame = CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: kTableViewHeight)
        consolesTableView = UITableView(frame: consolesTableViewFrame)
        consolesTableView?.backgroundColor = UIColor.clear
        consolesTableView?.delegate = self
        consolesTableView?.dataSource = self
        consolesTableView?.isScrollEnabled = true
        consolesTableView?.separatorStyle = .none
        consolesTableView?.clipsToBounds = false
        consolesTableView?.isUserInteractionEnabled = true
        consolesTableView?.rowHeight = kProfileCellHeight
        consolesTableView?.register(ProfileCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
        
        let gamesTableViewFrame = CGRect(x: (consolesTableView?.frame.maxX)!, y: 0, width: Utils.screenViewFrame().size.width, height: kTableViewHeight)
        gamesTableView = UITableView(frame: gamesTableViewFrame)
        gamesTableView?.backgroundColor = UIColor.clear
        gamesTableView?.delegate = self
        gamesTableView?.dataSource = self
        gamesTableView?.isScrollEnabled = true
        gamesTableView?.separatorStyle = .none
        gamesTableView?.clipsToBounds = false
        gamesTableView?.isUserInteractionEnabled = true
        gamesTableView?.rowHeight = kProfileCellHeight
        gamesTableView?.register(ProfileCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
        
        scrollView.contentSize = CGSize(width: (consolesTableView?.frame.width)! + (gamesTableView?.frame.width)!, height: scrollView.frame.height)
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        scrollView.addSubview(consolesTableView!)
        scrollView.addSubview(gamesTableView!)
    }
    
    @IBAction func onAvatarButtonTouch(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
        
        // Create take picture option action
        let takePictureAction = UIAlertAction(title: "Tomar Photo", style: .default) { action -> Void in
            self.takePicture()
        }
        actionSheetController.addAction(takePictureAction)
        
        // Create and add first option action
        let choosePictureAction = UIAlertAction(title: "Escoger imagen", style: .default) { action -> Void in
            self.takePickPhoto()
        }
        actionSheetController.addAction(choosePictureAction)
        
        if LocalDataManager.avatar != nil {
            let takePictureAction = UIAlertAction(title: "Eliminar Photo", style: .destructive) { action -> Void in
                self.deletePicture()
            }
            
            actionSheetController.addAction(takePictureAction)
        }
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func onConsolesButtonTouch(_ sender: Any) {
        let point: CGPoint = CGPoint(x: (consolesTableView?.frame.minX)!, y: 0.0)
        scrollView.setContentOffset(point, animated: true)
        consolesButton.setTitleColor(UIColor.white, for: .normal)
        gamesButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        UIView.animate(withDuration: 0.3) { 
            var tabSelectedSeparatorViewFrame: CGRect = self.tabSelectedSeparatorView.frame
            tabSelectedSeparatorViewFrame.origin.x = self.consolesButton.frame.minX
            self.tabSelectedSeparatorView.frame = tabSelectedSeparatorViewFrame
        }
    }
    
    @IBAction func onGamesButtonTouch(_ sender: Any) {
        let point: CGPoint = CGPoint(x: (gamesTableView?.frame.minX)!, y: 0.0)
        scrollView.setContentOffset(point, animated: true)
        consolesButton.setTitleColor(UIColor.lightGray, for: .normal)
        gamesButton.setTitleColor(UIColor.white, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            var tabSelectedSeparatorViewFrame: CGRect = self.tabSelectedSeparatorView.frame
            tabSelectedSeparatorViewFrame.origin.x = self.gamesButton.frame.minX
            self.tabSelectedSeparatorView.frame = tabSelectedSeparatorViewFrame
        }
    }
    
    @IBAction func onCompletedButtonTouch(_ sender: Any) {
        weak var weakSelf = self
        
        let console = consoles[0]
        let preferences: [String : Any] = [
            "console_id": "\(console.id)",
            "active": true,
            "games": gamesStr]
        
        var preferencesObj = [[String: Any]]()
        preferencesObj = [preferences]
        var jsonData: Data?
        var strDict: String?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: preferencesObj, options: .prettyPrinted)
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            strDict = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
                strDict = "\(dictFromJSON)"
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let params: [String: Any] = ["user_id": "\(user?.id ?? 0)",
                                     "preferences": strDict ?? ""
        ]
        
        AppDelegate.showPKHUD()
        ApiManager.createUser(createUserParameters: params) { (errorModel) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    strongSelf.profileCompleted()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError, completion: nil)
                    
                }
            }
        }
    }
    
    // MARK: ActionSheet actions
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
                picker.modalPresentationStyle = .fullScreen
            }
            
            present(picker, animated: true)
        }
    }
    
    func takePickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func deletePicture() {
        avatarImageView.image = UIImage(named: "avatar_placeholder")
        LocalDataManager.avatar = nil
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true)
            return
        }        
        
        
        // TODO: Move to other side
        if user != nil {
            if let data = UIImageJPEGRepresentation(image, 0.33) {
                let params: Parameters = ["user_id": "\(user!.id)"]
                
                dismiss(animated: true)
                weak var weakSelf = self
                AppDelegate.showPKHUD()
                ApiManager.uploadAvatarRequest(registerAvatarParameters: params, imageData: data, completion: { (errorModel) in
                    AppDelegate.hidePKHUD()
                    if let strongSelf = weakSelf {
                        if (errorModel?.success)! {
                            LocalDataManager.avatar = image
                            strongSelf.avatarImageView.image = image
                        } else {
                            DispatchQueue.main.async {
                                strongSelf.presentAlert(title: "Error", message: "Error desconocido, intente mas tarde", style: alertStyle.formError, completion: nil)
                            }
                        }
                    }
                })
            }
        }
    }
}

//MARK: UITableViewDelegate
extension ProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath != nil && selectedCellIndexPath?.compare(indexPath) == ComparisonResult.orderedSame {
            if tableView == consolesTableView {
                return kProfileCellHeight + kProfileCellConsolesHeight
            }
            
            return kProfileCellHeight
        }
        
        return kProfileCellHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedCellIndexPath != nil {
            if selectedCellIndexPath?.compare(indexPath) == ComparisonResult.orderedSame {
                selectedCellIndexPath = nil
                tableView.cellForRow(at: indexPath)?.isSelected = false
                tableView.reloadRows(at: [indexPath], with: .none)
                return nil
            } else {
                tableView.reloadRows(at: [selectedCellIndexPath!], with: .automatic)
            }
        } else {
            selectedCellIndexPath = indexPath
            tableView.reloadRows(at: [selectedCellIndexPath!], with: .automatic)
        }
    
        return indexPath
    }
    
}

//MARK: UITableViewDelegate
extension ProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == consolesTableView {
            if let consoles: [ConsoleModel] = LocalDataManager.consolesSelected {
                return consoles.count
            }
        } else {
            if let games: [GameModel] = LocalDataManager.gamesSelected {
                return games.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier) as! ProfileCell
        profileCell.selectionStyle = .none
        if tableView == consolesTableView {
            if let consoles: [ConsoleModel] = LocalDataManager.consolesSelected {
                let console = consoles[indexPath.row]
                
                profileCell.setGameImage(name: console.avatar, gameName: console.name, gameYear: console.year as NSNumber, gameNumber: "\(indexPath.row + 1)")
                if let games: [GameModel] = LocalDataManager.gamesSelected {
                    profileCell.setGames(games: games, width: profileCell.frame.width)
                }
                
                profileCell.isUserInteractionEnabled = true
                profileCell.hideYearLabel()
            }
        } else {
            if let games: [GameModel] = LocalDataManager.gamesSelected {
                let game = games[indexPath.row]
                
                profileCell.setGameImage(name: game.avatar, gameName: game.name, gameYear: game.year as NSNumber, gameNumber: "\(indexPath.row + 1)")
                profileCell.isUserInteractionEnabled = false
            }            
            
            profileCell.hideArrow()
        }
        
        profileCell.layoutIfNeeded()
        
        return profileCell
    }
}
