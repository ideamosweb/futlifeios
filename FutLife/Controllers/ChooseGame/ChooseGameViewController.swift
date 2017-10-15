//
//  ChooseGameViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/29/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChooseGameViewController: CarouselViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var chooseGameLabel: UILabel!
    @IBOutlet weak var chooseMoreThanOneLable: UILabel!
    
    var games: [Game]?
    var consoles: [Console]?
    var selectedConsoles = [ConsoleModel]()
    var selectedGames: [[GameModel]]?
    var isNavBar: Bool?
    var isUpdate: Bool?
    var chooseGameCompleted: (([[GameModel]]) -> Void)?
    var gamesStr = [Any]()
    var user: UserModel?
    
    let VIEW_ITEM_WIDTH: CGFloat = 225
    let VIEW_ITEM_HEIGHT: CGFloat = 282
    let carousels_margin_top: CGFloat = 10
    let carousels_padding: CGFloat = 0
    let carousels_height: CGFloat = 330
    
    let enableMultipleCarousels: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, isUpdate: Bool, chooseGameCompleted: (([[GameModel]]) -> Void)?) {
        self.chooseGameCompleted = chooseGameCompleted
        super.init(nibName: "ChooseGameViewController", bundle: Bundle.main)
        isNavBar = navBar
        self.isUpdate = isUpdate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselSource = .games
        
        chooseGameLabel.font = UIFont().bebasBoldFont(size: 38)
        chooseMoreThanOneLable.font = UIFont().bebasFont(size: 18)
        nextButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: isNavBar!)
        
        getGames()
        
        NotificationCenter.default.removeObserver(self)
        
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselsItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCarouselsItem(_:)), name: selectedCarouselItem, object: nil)
    }
    
    deinit {
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselsItemNotification)
        NotificationCenter.default.removeObserver(self, name: selectedCarouselItem, object: nil)
    }
    
    private func createCarousels(withItems: [Game]) {
        var carousels = [iCarousel]()
        var previousCarousel: iCarousel?
        let numberOfCarousels = (!enableMultipleCarousels) ? 1 : selectedConsoles.count
        for index in stride(from: 0, to: numberOfCarousels, by: 1) {
            let consoleModel: ConsoleModel = selectedConsoles[index]
            if previousCarousel != nil {
                let placeholderImage = UIImage(named: "loading_game")!
                let consoleImage = UIImageView(frame: CGRect(x: (Utils.screenViewFrame().width / 2) - 45, y: (previousCarousel?.frame.maxY)! + carousels_padding, width: 40, height: 35))
                consoleImage.af_setImage(withURL: URL(string: consoleModel.avatar)!, placeholderImage: placeholderImage)
                
                let consoleLb = UILabel(frame: CGRect(x: consoleImage.frame.maxX + 10, y: consoleImage.frame.midY - 11, width: 100, height: 22))
                consoleLb.textAlignment = .left
                consoleLb.textColor = UIColor.white
                consoleLb.font = UIFont().bebasBoldFont(size: 20)
                consoleLb.text = consoleModel.name
                
                let carousel = iCarousel(frame: CGRect(x: 0, y: consoleImage.frame.maxY, width: Utils.screenViewFrame().width, height: carousels_height))
                carousel.type = .custom
                carousel.delegate = self
                carousel.dataSource = self
                carousel.bounceDistance = 0.3
                carousel.scrollSpeed = 0.3
                carousel.tag = index
                let viewItems: [UIView] = configCarouselsItemsViews(games: withItems)
                items.append(viewItems)
                
                previousCarousel = carousel
                carousels.append(carousel)
                scrollView?.addSubview(consoleImage)
                scrollView?.addSubview(consoleLb)
                scrollView?.addSubview(carousel)
            } else {
                let placeholderImage = UIImage(named: "loading_game")!
                let consoleImage = UIImageView(frame: CGRect(x: (Utils.screenViewFrame().width / 2) - 45, y: carousels_margin_top, width: 40, height: 35))
                consoleImage.af_setImage(withURL: URL(string: consoleModel.avatar)!, placeholderImage: placeholderImage)
                
                let consoleLb = UILabel(frame: CGRect(x: consoleImage.frame.maxX + 10, y: consoleImage.frame.midY - 11, width: 100, height: 22))
                consoleLb.textAlignment = .left
                consoleLb.textColor = UIColor.white
                consoleLb.font = UIFont().bebasBoldFont(size: 20)
                consoleLb.text = consoleModel.name
                
                let carousel = iCarousel(frame: CGRect(x: 0, y: consoleImage.frame.maxY, width: Utils.screenViewFrame().width, height: carousels_height))
                carousel.type = .custom
                carousel.delegate = self
                carousel.dataSource = self
                carousel.bounceDistance = 0.3
                carousel.scrollSpeed = 0.3
                carousel.tag = index
                let viewItems: [UIView] = configCarouselsItemsViews(games: withItems)
                items.append(viewItems)
                
                previousCarousel = carousel
                carousels.append(carousel)
                scrollView?.addSubview(consoleImage)
                scrollView?.addSubview(consoleLb)
                scrollView?.addSubview(carousel)
            }
        }
        
        self.carousels = carousels
    }
    
    private func getGames() {
        var isSelectedConsoles = false
        if (LocalDataManager.consolesSelected?.count)! > 0 {
            selectedConsoles = LocalDataManager.consolesSelected!
            selectedGames = [[GameModel?]?](repeating: [], count: selectedConsoles.count) as? [[GameModel]]
            isSelectedConsoles = true
        }
        
        if let games: [Game] = ConfigurationParametersModel.games {
            if games.count > 0 {
                createCarousels(withItems: games)
                self.games = games
            }
            
            carouselsReloadData()
        }
        
        indexSelectedItems = ([[Int?]?](repeating: [], count: selectedConsoles.count) as? [[Int]])!
        
        if selectedConsoles.count > 0 && isSelectedConsoles {
            if let consoles: [Console] = ConfigurationParametersModel.consoles {
                if consoles.count > 0 {
                    self.consoles = consoles
                }
            }
            
            var indexCrsl = 0
            let gamesSelected: [[GameModel]] = Utils.retrieveGames(consoles: selectedConsoles)
            selectedItemsRecorded = ([[Bool?]?](repeating: [], count: selectedConsoles.count) as? [[Bool]])!
            for gameModel: [GameModel] in gamesSelected {
                var index = 0
                selectedItems.removeAll()
                for games in self.games! {
                    selectedItemsRecorded?[indexCrsl].append(false)
                    for gmMdl in gameModel {
                        if games.id == gmMdl.id {
                            selectedItems.append(index)
                            selectedItemsRecorded?[indexCrsl][index] = true
                        }
                    }
                    
                    index += 1
                }
                
                // Add consoles to first carousel
                indexSelectedItems[indexCrsl] = selectedItems
                carouselsReloadData()
                indexCrsl += 1
            }
        }
        
        var enableButton: Bool = true
        for items in indexSelectedItems {
            if items.count <= 0 {
                enableButton = false
            }
        }
        
        nextButton.isEnabled = enableButton
    }
    
    private func configCarouselsItemsViews(games: [Game]) -> [UIView] {
        var carouselItemsViews = [UIImageView]()
        for game in games {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: VIEW_ITEM_WIDTH, height: VIEW_ITEM_HEIGHT))
            let imageUrl = URL(string: game.avatar!)!
            let placeholderImage = UIImage(named: "loading_game")!
            
            imageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
            
            carouselItemsViews.append(imageView)
        }
        
        return carouselItemsViews
    }
    
    //MARK: iCarousel delegate methods
    func didSelectCarouselsItem(_ notification: NSNotification) {
        var enableButton: Bool = true
        for items in indexSelectedItems {
            if items.count <= 0 {
                enableButton = false
            }
        }
        
        nextButton.isEnabled = enableButton
    }
    
    func updatePreferences() {
        weak var weakSelf = self
        
        var preferences = [[String : Any]]()
        var index = 0
        for console: ConsoleModel in selectedConsoles {
            let games: [GameModel] = LocalDataManager.gamesSelected![index]
            gamesStr = [Any]()
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
            
            let preference: [String : Any] = [
                "console_id": "\(console.id)",
                "active": true,
                "games": gamesStr]
            
            preferences.append(preference)
            index += 1
        }
        
        var preferencesObj = [[String: Any]]()
        preferencesObj = preferences
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
            "preferences": strDict ?? "",
            "edit": "0"
        ]
        
        AppDelegate.showPKHUD()
        ApiManager.createUser(createUserParameters: params) { (errorModel) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    strongSelf.showSuccessMessage()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError, completion: nil)
                    
                }
            }
        }
    }
    
    func showSuccessMessage() {
        let alertController = UIAlertController(title: "¡Felicitaciones!", message: "Tus preferencias se han actualizado con exito!.", preferredStyle: UIAlertControllerStyle.alert)
        
        weak var weakSelf = self
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            if let strongSelf = weakSelf {
                AppDelegate.showPKHUD()
                strongSelf.goToHome()
            }
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func goToHome() {
        let homeVC = HomeViewController(completion: nil)
        
        AppDelegate.sharedInstance.goToHome(homeViewController: homeVC)
    }
    
    @IBAction func onNextButtonTouch(_ sender: Any) {
        var index = 0
        for items in indexSelectedItems {
            for item in items {
                let game = games?[item]
                let newGameModel = GameModel(id: game?.id, year: game?.year, name: game?.name, avatar: game?.avatar, thumbnail: game?.thumbnail, active: game?.active, createdAt: game?.createdAt, updatedAt: game?.updatedAt)
                selectedGames?[index].append(newGameModel)
            }
            
            index += 1
        }
        
        LocalDataManager.gamesSelected = selectedGames
        
        if !isUpdate! {
            chooseGameCompleted!(selectedGames!)
        } else {
            user = LocalDataManager.user!
            updatePreferences()
        }
    }
}

