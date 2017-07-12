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

class ProfileViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    var consoles = [ConsoleModel]()
    
    var isConfirmButton: Bool
    var isNavBar: Bool
    var profileCompleted: () -> Void
    
    let kTableViewHeight: CGFloat = 480.0
    let kProfileCellHeight: CGFloat = 44.0
    let kProfileConsoleCellHeight: CGFloat = 22.0
    let kProfileCellIdentifier = "ProfileCell"
    
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
        consoles = LocalDataManager.consolesSelected!
        user = LocalDataManager.user!
        if user != nil {
            nameLabel.text = user?.name
            userNameLabel.text = user?.userName
        }
        
        navigationItem.title = isConfirmButton ? "Resumen" : "Perfil"
        completedRegisterButton.isHidden = !isConfirmButton
        
        //guard !UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        avatarImageView.circularView()
        
        configTablesAndScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        showNavigationBar(show: isNavBar)
        
        if let avatar: UIImage = LocalDataManager.avatar {
            avatarImageView.image = avatar
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubview(toFront: completedRegisterButton)
    }
    
    private func configTablesAndScrollView() {
        let consolesTableViewFrame = CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: kTableViewHeight)
        let consolesDataSource = ProfileConsolesTableViewDataSource()
        consolesTableView = UITableView(frame: consolesTableViewFrame)
        consolesTableView?.backgroundColor = UIColor.clear
        consolesTableView?.delegate = consolesDataSource
        consolesTableView?.dataSource = consolesDataSource
        consolesTableView?.isScrollEnabled = true
        consolesTableView?.separatorStyle = .none
        consolesTableView?.clipsToBounds = false
        consolesTableView?.isUserInteractionEnabled = false
        consolesTableView?.register(ProfileCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
        
        let gamesTableViewFrame = CGRect(x: (consolesTableView?.frame.maxX)!, y: 0, width: Utils.screenViewFrame().size.width, height: kTableViewHeight)
        let gamesDataSource = ProfileGamesTableViewDataSource()
        gamesTableView = UITableView(frame: gamesTableViewFrame)
        gamesTableView?.backgroundColor = UIColor.clear
        gamesTableView?.delegate = gamesDataSource
        gamesTableView?.dataSource = gamesDataSource
        gamesTableView?.isScrollEnabled = true
        gamesTableView?.separatorStyle = .none
        gamesTableView?.clipsToBounds = false
        gamesTableView?.isUserInteractionEnabled = false
        gamesTableView?.register(ProfileCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
        
        scrollView.contentSize = CGSize(width: (consolesTableView?.frame.width)! + (gamesTableView?.frame.width)!, height: scrollView.frame.height)
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        scrollView.addSubview(consolesTableView!)
        scrollView.addSubview(gamesTableView!)
    }
    
    @IBAction func onAvatarButtonTouch(_ sender: Any) {
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
    
    @IBAction func onConsolesButtonTouch(_ sender: Any) {
        let point: CGPoint = CGPoint(x: (consolesTableView?.frame.minX)!, y: 0.0)
        scrollView.setContentOffset(point, animated: true)
        
        UIView.animate(withDuration: 0.3) { 
            var tabSelectedSeparatorViewFrame: CGRect = self.tabSelectedSeparatorView.frame
            tabSelectedSeparatorViewFrame.origin.x = self.consolesButton.frame.minX
            self.tabSelectedSeparatorView.frame = tabSelectedSeparatorViewFrame
        }
    }
    
    @IBAction func onGamesButtonTouch(_ sender: Any) {
        let point: CGPoint = CGPoint(x: (gamesTableView?.frame.minX)!, y: 0.0)
        scrollView.setContentOffset(point, animated: true)
        
        UIView.animate(withDuration: 0.3) {
            var tabSelectedSeparatorViewFrame: CGRect = self.tabSelectedSeparatorView.frame
            tabSelectedSeparatorViewFrame.origin.x = self.gamesButton.frame.minX
            self.tabSelectedSeparatorView.frame = tabSelectedSeparatorViewFrame
        }
    }
    
    @IBAction func onCompletedButtonTouch(_ sender: Any) {
        weak var weakSelf = self
        
        // TODO: Move to other side
//        var gamesStr = [String: String]()
//        for game: GameModel in games {
//            gamesStr["game_id"] = "\(game.id)"
//            gamesStr["active"] = "true∫"
//        }
        let console = consoles[0]
        let params: Parameters = ["user_id": user?.id ?? "",
                                  "preferences": [
                                    "console_id": console.id,
                                    "active": true,
                                    "games": games]
        ]
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        ApiManager.createUser(createUserParameters: params) { (errorModel) in
            PKHUD.sharedHUD.hide(afterDelay: 0)
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    //strongSelf.registerCompleted()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                    
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true)
            return
        }
        
        avatarImageView.image = image
        
        
        // TODO: Move to other side
        if user != nil {
            if let data = UIImagePNGRepresentation(image) {
                let params: Parameters = ["user_id": user!.id,
                                          "avatar": data
                ]
                
                dismiss(animated: true)
                weak var weakSelf = self
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                ApiManager.uploadAvatarRequest(registerAvatarParameters: params, completion: { (errorModel) in
                    PKHUD.sharedHUD.hide(afterDelay: 0)
                    if let strongSelf = weakSelf {
                        if (errorModel?.success)! {
                            //strongSelf.registerCompleted()
                        } else {
                            DispatchQueue.main.async {
                                strongSelf.presentAlert(title: "Error", message: "Error desconocido, intente mas tarde", style: alertStyle.formError)
                                
                            }
                        }
                        
                        LocalDataManager.avatar = image
                    }
                    
                })
                
            }
            
        }
        
        
        /*upload(
         image: image,
         progressCompletion: { [unowned self] percent in
         self.progressView.setProgress(percent, animated: true)
         },
         completion: { [unowned self] tags, colors in
         self.takePictureButton.isHidden = false
         self.progressView.isHidden = true
         self.activityIndicatorView.stopAnimating()
         
         self.tags = tags
         self.colors = colors
         
         self.performSegue(withIdentifier: "ShowResults", sender: self)
         })*/
        
        //dismiss(animated: true)
    }
}
