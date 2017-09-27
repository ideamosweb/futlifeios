//
//  ChooseGameViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/29/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChooseGameViewController: CarouselViewController {
    //@IBOutlet weak var gameCarousel: iCarousel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var chooseGameLabel: UILabel!
    @IBOutlet weak var chooseMoreThanOneLable: UILabel!
    
    var games: [Game]?
    var selectedConsoles = [ConsoleModel]()
    var selectedGames: [[GameModel]]?
    var selectedGamesTable: UITableView?
    var isNavBar: Bool?
    var chooseGameCompleted: (([[GameModel]]) -> Void)?
    
    let VIEW_ITEM_WIDTH: CGFloat = 225
    let VIEW_ITEM_HEIGHT: CGFloat = 282
    let carousels_margin_top: CGFloat = 10
    let carousels_padding: CGFloat = 0
    let carousels_height: CGFloat = 330
    
    let enableMultipleCarousels: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, chooseGameCompleted: (([[GameModel]]) -> Void)?) {
        self.chooseGameCompleted = chooseGameCompleted
        super.init(nibName: "ChooseGameViewController", bundle: Bundle.main)
        isNavBar = navBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseGameLabel.font = UIFont().bebasBoldFont(size: 38)
        chooseMoreThanOneLable.font = UIFont().bebasFont(size: 18)
        
        // Check if there selected games
        let preferences = LocalDataManager.user?.preferences
        if (preferences?.count)! > 0 {
            selectedConsoles = Utils.retrieveConsoles()
            nextButton.isEnabled = true
        } else {
            selectedConsoles = LocalDataManager.consolesSelected!
        }
        
        selectedGames = [[GameModel?]?](repeating: [], count: selectedConsoles.count) as? [[GameModel]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: isNavBar!)
        nextButton.isEnabled = false
        
        // Let's add carousels items
//        let consoles = LocalDataManager.consolesSelected
//        if let consoles = consoles {
//            if consoles.count > 0 {
//                let carousel = iCarousel(frame: CGRect(x: gameCarousel.frame.minX, y: gameCarousel.frame.maxY + 20, width: gameCarousel.frame.width, height: gameCarousel.frame.height))
//                carousels.append(carousel)
//            }
//        }
        //carousels = [gameCarousel]
        
        getGames()
        
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCarouselItem(_:)), name: selectedCarouselItem, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //addSelectedGames()
    }
    
    deinit {
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
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
        if let games: [Game] = ConfigurationParametersModel.games {
            if games.count > 0 {
                createCarousels(withItems: games)
                self.games = games
            }
            
            carouselsReloadData()
        }
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
    func didSelectCarouselItem(_ notification: NSNotification) {
        nextButton.isEnabled = indexSelectedItems.count > 0
        
        if let indexCarousel = notification.userInfo?["carousel"] as? Int {
            if let index = notification.userInfo?["index"] as? Int {
                //let consoleModel: ConsoleModel
                let gameModel: GameModel
                if selectedConsoles.count > 0 {
                    //consoleModel = selectedConsoles[indexCarousel]
                    if (selectedGames?[indexCarousel].count)! > 0 && index < (selectedGames?[indexCarousel].count)! {
                        gameModel = (selectedGames?[indexCarousel][index])!
                        if let indexObject = selectedGames?[indexCarousel].index(where: {$0 === gameModel}) {
                            selectedGames?[indexCarousel].remove(at: indexObject)
                        } else {
                            selectedGames?[indexCarousel].append(gameModel)
                        }
                    } else {
                        let game = games?[index]
                        let newGameModel = GameModel(id: game?.id, year: game?.year, name: game?.name, avatar: game?.avatar, thumbnail: game?.thumbnail, active: game?.active, createdAt: game?.createdAt, updatedAt: game?.updatedAt)
                        if let indexObject = selectedGames?[indexCarousel].index(where: {$0 === newGameModel}) {
                            selectedGames?[indexCarousel].remove(at: indexObject)
                        } else {
                            selectedGames?[indexCarousel].append(newGameModel)
                        }
                        
                        //selectedConsoles[indexCarousel].games = selectedGames
                    }
                    
                }
                
                selectedGamesTable?.reloadData()
                
            }
        }
    }
    
    @IBAction func onNextButtonTouch(_ sender: Any) {
        LocalDataManager.gamesSelected = selectedGames
        chooseGameCompleted!(selectedGames!)
    }
    

    
    
    
    
}

// MARK: UITableViewDelegate
extension ChooseGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}

// MARK: UITableViewDatasource
extension ChooseGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedGames?.count)! > 0 {
            return selectedGames!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        //let game = selectedGames?[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont().bebasFont(size: 18.0)
        //cell.textLabel?.text = "\(game.name ?? "")"
        
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
