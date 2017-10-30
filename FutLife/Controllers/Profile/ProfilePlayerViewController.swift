//
//  ProfilePlayerViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar
import Alamofire
import PKHUD

class ProfilePlayerViewController: TabsViewController {
    var avatar: UIImage?
    var name: String!
    var userName: String!
    var player: UserModel!
    var consoles: [ConsoleModel]!
    var games: [GameModel]!
    var selectedButtonView: UIView!
    var userInfoButton: UIButton!
    var editButton: UIButton?
    var infoEditButton: UIButton?
    var consoleEditButton: UIButton?
    var scrollView: UIScrollView?
    
    var statisticsTable: UITableView!
    var consolesTableView: UITableView!
    
    var playerInfo: [Any]!
    let profileType: PlayerProfileType!
    var playerAvatar: UIImageView!
    var playerAvatarButton: UIButton!
    var avatarSet: Bool = false
    var profileCompleted: (() -> Void?)?
    var isOpenEditButtons: Bool = false
    var playerInfoVC: PlayerInfoViewController?
    
    let kProfileCellIdentifier = "ProfileCell"
    let kFlexibleBarHeight: CGFloat = 280.0
    let kEditButtonSide = 60.0
    let kInfoEditButtonSide = 40.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: UserModel, type: PlayerProfileType, profileCompleted: (() -> Void)?) {
        self.player = player
        self.profileType = type
        self.profileCompleted = profileCompleted
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar(show: true)
        view.backgroundColor = UIColor.white
        
        configFlexibleHeader()
    }
    
    func configFlexibleHeader() {
        let navBarHeight = CGFloat(Constants.kStatusBarDefaultHeight) + CGFloat(Constants.kNavigationBarDefaultHeight)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height + navBarHeight))
        scrollView?.contentSize = CGSize(width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height + kFlexibleBarHeight - CGFloat(Constants.kNavigationBarDefaultHeight) - 20)
        view.addSubview(scrollView!)
        scrollView?.bounces = false
        
        /*** FLEXIBLE NAV-BAR ***/
        let myBar: BLKFlexibleHeightBar = BLKFlexibleHeightBar(frame: CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: kFlexibleBarHeight))
        myBar.minimumBarHeight = navBarHeight
        myBar.behaviorDefiner = SquareCashStyleBehaviorDefiner()
        
        scrollView?.delegate = myBar.behaviorDefiner as UIScrollViewDelegate
        
        /*** BACKGROUND BAR IMAGE ***/
        let bgBarImage = UIImage(named: "headerFlexNavBg")
        let bgBarimageFrame = CGRect(x: 0, y: -64, width: myBar.frame.size.width, height: myBar.frame.height + 20)
        let bgBarImageView = UIImageView(frame: bgBarimageFrame)
        bgBarImageView.image = bgBarImage
        bgBarImageView.layer.cornerRadius = 100
        
        myBar.addSubview(bgBarImageView)
        
        let initialLayoutAttributesForBG: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForBG.size = bgBarImageView.frame.size
        initialLayoutAttributesForBG.center = CGPoint(x: myBar.bounds.midX, y: navBarHeight + 18)
        
        // This is what we want the bar to look like at its maximum height (progress == 0.0)
        bgBarImageView.add(initialLayoutAttributesForBG, forProgress: 0.0)
        
        // Create a final set of layout attributes based on the same values as the initial layout attributes
        let finalLayoutAttributesForBG: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForBG)
        finalLayoutAttributesForBG.alpha = 1.0
        let translationForBG = CGAffineTransform(translationX: 0, y: 0)
        let scaleForBG = CGAffineTransform(scaleX: 1, y: 1)
        let concatTransform = scaleForBG.concatenating(translationForBG)
        finalLayoutAttributesForBG.transform = concatTransform
        
        // This is what we want the bar to look like at its minimum height (progress == 1.0)
        bgBarImageView.add(finalLayoutAttributesForBG, forProgress: 1.0)
        
        /*** NAVBAR VIEW ***/
        let navBarHeaderFrame = CGRect(x: myBar.bounds.minX, y: 0, width: Utils.screenViewFrame().size.width, height: CGFloat(Constants.kStatusBarDefaultHeight) + CGFloat(Constants.kNavigationBarDefaultHeight))
        let navBar = UIView(frame: navBarHeaderFrame)
        navBar.backgroundColor = UIColor().darkBlue()
        
        myBar.addSubview(navBar)
        
        let initialLayoutAttributesForNB: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForNB.size = navBar.frame.size
        initialLayoutAttributesForNB.center = CGPoint(x: myBar.bounds.midX, y: -(navBarHeight / 2))
        initialLayoutAttributesForNB.alpha = 0.0
        
        // This is what we want the bar to look like at its maximum height (progress == 0.0)
        navBar.add(initialLayoutAttributesForNB, forProgress: 0.0)
        
        // Create a final set of layout attributes based on the same values as the initial layout attributes
        let finalLayoutAttributesForNB: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForNB)
        finalLayoutAttributesForNB.alpha = 1.0
        let translationForNB = CGAffineTransform(translationX: 0.0, y: kFlexibleBarHeight - 64)
        finalLayoutAttributesForNB.transform = translationForNB
        
        // This is what we want the bar to look like at its minimum height (progress == 1.0)
        navBar.add(finalLayoutAttributesForNB, forProgress: 1.0)
        
        /*** AVATAR IMAGE ***/
        let avatarWraperView = UIView(frame: CGRect(x: Utils.screenViewFrame().midX, y: CGFloat(Constants.kNavigationBarDefaultHeight), width: 160, height: 150))
        playerAvatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        playerAvatar.contentMode = .scaleAspectFill
        
        Utils.setAvatar(imageView: playerAvatar)
        playerAvatar.circularView(borderColor: UIColor().greenDefault())
        
        playerAvatarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        playerAvatarButton.addTarget(self, action: #selector(onUserAvatarButtonTouch), for: .touchUpInside)
        
        let cameraViewWrap = UIView(frame: CGRect(x: playerAvatar.frame.maxX - 40, y: avatarWraperView.frame.maxY - 80, width: 40, height: 40))
        cameraViewWrap.backgroundColor = UIColor().greenDefault()
        cameraViewWrap.circularView(borderColor: UIColor.clear)
        
        let cameraView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        cameraView.image = UIImage(named: "ic_camera_white")
        cameraView.contentMode = .scaleAspectFill
        
        cameraViewWrap.addSubview(cameraView)
        
        avatarWraperView.addSubview(playerAvatar)
        avatarWraperView.addSubview(cameraViewWrap)
        avatarWraperView.addSubview(playerAvatarButton)
        
        myBar.addSubview(avatarWraperView)
        
        let initialLayoutAttributesForAvatar: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForAvatar.size = playerAvatar.frame.size
        initialLayoutAttributesForAvatar.center = CGPoint(x: myBar.bounds.midX, y: navBarHeight + 20)
        
        avatarWraperView.add(initialLayoutAttributesForAvatar, forProgress: 0.0)
        
        let finalLayoutAttributesForAvatar: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForAvatar)
        finalLayoutAttributesForAvatar.alpha = 0.0
        let translationForAvatar = CGAffineTransform(translationX: 0.0, y: -100.0)
        let scaleForAvatar = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let avatarTransformConcat = scaleForAvatar.concatenating(translationForAvatar)
        finalLayoutAttributesForAvatar.transform = avatarTransformConcat
        
        avatarWraperView.add(finalLayoutAttributesForAvatar, forProgress: 1.0)
        
        /*** USERNAME LABEL ***/
        let userNameLb = UILabel()
        userNameLb.text = player.userName
        userNameLb.font = UIFont().bebasBoldFont(size: 20)
        userNameLb.textColor = UIColor.white
        userNameLb.sizeToFit()
        userNameLb.frame.origin.x = myBar.bounds.midX
        userNameLb.frame.origin.y = avatarWraperView.frame.maxY - 10
        myBar.addSubview(userNameLb)
        
        let initialLayoutAttributesForUserName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForUserName.size = userNameLb.frame.size
        initialLayoutAttributesForUserName.center = CGPoint(x: myBar.bounds.midX, y: avatarWraperView.frame.maxY - 10)
        
        userNameLb.add(initialLayoutAttributesForUserName, forProgress: 0.0)
        
        let finalLayoutAttributesForUserName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForUserName)
        let translationForUserName = CGAffineTransform(translationX: 0.0, y: 10.0)
        let scaleForUserName = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let userNameTransConcat = scaleForUserName.concatenating(translationForUserName)
        finalLayoutAttributesForUserName.transform = userNameTransConcat
        
        userNameLb.add(finalLayoutAttributesForUserName, forProgress: 1.0)
        
        /*** NAME LABEL ***/
        let nameLb = UILabel()
        nameLb.text = player.name
        nameLb.font = UIFont().bebasBoldFont(size: 18)
        nameLb.textColor = UIColor.lightGray
        nameLb.sizeToFit()
        myBar.addSubview(nameLb)
        
        let initialLayoutAttributesForName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForName.size = nameLb.frame.size
        initialLayoutAttributesForName.center = CGPoint(x: myBar.bounds.midX, y: userNameLb.frame.maxY + 3)
        
        nameLb.add(initialLayoutAttributesForName, forProgress: 0.0)
        
        let finalLayoutAttributesForName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForName)
        finalLayoutAttributesForName.alpha = 0.0
        let translationForName = CGAffineTransform(translationX: 0.0, y: -250.0)
        let scaleForName = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let nameTransConcat = scaleForName.concatenating(translationForName)
        finalLayoutAttributesForName.transform = nameTransConcat
        
        nameLb.add(finalLayoutAttributesForName, forProgress: 1.0)
        
        // Finally add myBar to main view
        scrollView?.addSubview(myBar)
        
        // Config tabs
        useDefaultViewHeight = true
        tabsBellowView = bgBarImageView
        insertInView = scrollView
        showTabDefault = 1
        configPlayerViews()
        
        scrollView?.didMoveToSuperview()
        
        addEditButtons()
    }
    
    func addEditButtons() {
        let editButtonFrame = CGRect(x: Utils.screenViewFrame().width - 20 - CGFloat(kEditButtonSide), y: Utils.screenViewFrame().height - 5 - CGFloat(kEditButtonSide), width: CGFloat(kEditButtonSide), height: CGFloat(kEditButtonSide))
        editButton = UIButton(frame: editButtonFrame)
        editButton?.setImage(UIImage(named: "ic_edit_info"), for: .normal)
        editButton?.backgroundColor = UIColor().greenDefault()
        editButton?.layer.shadowColor = UIColor.black.cgColor
        editButton?.layer.shadowOpacity = 1
        editButton?.layer.shadowOffset = CGSize.zero
        editButton?.layer.shadowRadius = 50.0
        editButton?.circularView(borderColor: UIColor.clear)
        
        editButton?.addTarget(self, action: #selector(onEditButtonTouch), for: .touchUpInside)
        
        view.addSubview(editButton!)
        
        let infoEditButtonFrame = CGRect(x: (editButton?.frame.midX)! - (CGFloat(kInfoEditButtonSide) / 2), y: (editButton?.frame.midY)! - (CGFloat(kInfoEditButtonSide) / 2), width: CGFloat(kInfoEditButtonSide), height: CGFloat(kInfoEditButtonSide))
        infoEditButton = UIButton(frame: infoEditButtonFrame)
        let infoEditImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        infoEditImageView.image = UIImage(named: "ic_information")
        infoEditButton?.setImage(infoEditImageView.image, for: .normal)
        infoEditButton?.backgroundColor = UIColor(red: 50/255, green: 112/255, blue: 211/255, alpha: 1.0)
        infoEditButton?.circularView(borderColor: UIColor.clear)
        infoEditButton?.addTarget(self, action: #selector(onEditInfoButtonTouch), for: .touchUpInside)
        infoEditButton?.alpha = 0.0
        
        view.addSubview(infoEditButton!)
        
        let consoleEditButtonFrame = CGRect(x: (editButton?.frame.midX)! - (CGFloat(kInfoEditButtonSide) / 2), y: (editButton?.frame.midY)! - (CGFloat(kInfoEditButtonSide) / 2), width: CGFloat(kInfoEditButtonSide), height: CGFloat(kInfoEditButtonSide))
        consoleEditButton = UIButton(frame: consoleEditButtonFrame)
        let consoleEditImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        consoleEditImageView.image = UIImage(named: "ic_preferences")
        consoleEditButton?.setImage(consoleEditImageView.image, for: .normal)
        consoleEditButton?.backgroundColor = UIColor(red: 187/255, green: 62/255, blue: 62/255, alpha: 1.0)
        consoleEditButton?.circularView(borderColor: UIColor.clear)
        consoleEditButton?.addTarget(self, action: #selector(onEditConsoleTouch), for: .touchUpInside)
        consoleEditButton?.alpha = 0.0
        
        view.addSubview(consoleEditButton!)
    }
    
    func openEditAnimation() {
        editButton?.rotateAnimation(degrees: 50, duration: 0.5)
        
        infoEditButton?.fadeIn(duration: 0.5, alpha: 1.0, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.infoEditButton?.frame.origin.y = (self.infoEditButton?.frame.minY)! - 60
        }
        
        consoleEditButton?.fadeIn(duration: 0.5, alpha: 1.0, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.consoleEditButton?.frame.origin.y = (self.consoleEditButton?.frame.minY)! - 108
        }
        
        isOpenEditButtons = true
    }
    
    func closeEditAnimation() {
        editButton?.rotateAnimation(degrees: 50, duration: 0.5)
        
        infoEditButton?.fadeOut(duration: 0.5, alpha: 0.0, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.infoEditButton?.frame.origin.y = (self.editButton?.frame.midY)! - (CGFloat(self.kInfoEditButtonSide) / 2)
        }
        
        consoleEditButton?.fadeOut(duration: 0.5, alpha: 0.0, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.consoleEditButton?.frame.origin.y = (self.editButton?.frame.midY)! - (CGFloat(self.kInfoEditButtonSide) / 2)
        }
        
        isOpenEditButtons = false
    }
    
    func onEditButtonTouch() {
        if !isOpenEditButtons {
            openEditAnimation()
        } else {
            closeEditAnimation()
        }
    }
    
    func onEditConsoleTouch() {
        MenuManager().onEditConsoleTouch(currentViewController: self)
    }
    
    func onEditInfoButtonTouch() {
        scrollToTab(tab: 2)
        addDarkBg()
        tabs(enabled: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelBarItemTouch))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneBarItemmTouch))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDidEditInfoItemNotification), object: nil, userInfo: nil)
    }
    
    func onCancelBarItemTouch() {
        removeNavBarButtons()
        removeDarkBg()
        closeEditAnimation()
        tabs(enabled: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDidCancelInfoItemNotification), object: nil, userInfo: nil)
        
        view.endEditing(true)
    }
    
    func onDoneBarItemmTouch() {
        removeNavBarButtons()
        removeDarkBg()
        closeEditAnimation()
        tabs(enabled: true)
        
        let user: UserModel? = LocalDataManager.user!
        if user != nil {
            if let playerInfoVC = playerInfoVC {
                let params: Parameters = playerInfoVC.retriveFieldsValues()
                
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
    }
    
    func removeNavBarButtons() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        addBackButton()
    }
    
    func addDarkBg() {
        let darkBg = UIView(frame: CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height))
        darkBg.backgroundColor = UIColor.black
        darkBg.alpha = 0.7
        darkBg.tag = -1
        scrollView?.insertSubview(darkBg, at: 1)
    }
    
    func removeDarkBg() {
        for view in (scrollView?.subviews)! {
            if view.tag == -1 {
                view.removeFromSuperview()
            }
        }
    }
    
    func configPlayerViews() {
        let consolesSelected: [ConsoleModel] = Utils.retrieveConsoles()
        let gamesSelected: [[GameModel]] = Utils.retrieveGames()
        
        let playerConsolesVC = PlayerConsolesViewController(consoles: consolesSelected, games: gamesSelected)
        playerInfoVC = PlayerInfoViewController(consoles: consolesSelected)
        playerInfoVC?.formScrollViewDelegate = self
        let playerStatisticsVC = PlayerStatisticsViewController()
        
        tabsTitles = ["CONSOLAS", "INFORMACIÓN", "ESTADISTICAS"]
        tabsViewControllers = [playerConsolesVC, playerInfoVC!, playerStatisticsVC]
        reloadTabs()
    }
    
    func onUserAvatarButtonTouch() {
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
        playerAvatar.image = UIImage(named: "avatar_placeholder")
        LocalDataManager.avatar = nil
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfilePlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true)
            return
        }
        
        // TODO: Move to other side
        if player != nil {
            if let data = UIImageJPEGRepresentation(image, 0.33) {
                let params: Parameters = ["user_id": "\(player!.id)"]
                
                dismiss(animated: true)
                weak var weakSelf = self
                AppDelegate.showPKHUD()
                ApiManager.uploadAvatarRequest(registerAvatarParameters: params, imageData: data, completion: { (errorModel) in
                    AppDelegate.hidePKHUD()
                    if let strongSelf = weakSelf {
                        if (errorModel?.success)! {
                            LocalDataManager.avatar = image
                            strongSelf.playerAvatar.image = image
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

//MARK: FormScrollViewProtocol
extension ProfilePlayerViewController: FormScrollViewProtocol {
    func getFormScrollView() -> UIScrollView {
        if let scrollView = scrollView {
            return scrollView
        }
        
        return UIScrollView()
    }
}
