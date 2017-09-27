//
//  ChooseGameViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/29/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChooseGameViewController: CarouselViewController {
    @IBOutlet weak var gameCarousel: iCarousel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var chooseGameLabel: UILabel!
    @IBOutlet weak var chooseMoreThanOneLable: UILabel!
    
    var games: [Game]?
    var selectedConsoles = [PreferencesModel]()
    var selectedGames = [GameModel]()
    var selectedGamesTable: UITableView?
    var isNavBar: Bool?
    var chooseGameCompleted: (([GameModel]) -> Void)?
    
    let VIEW_ITEM_WIDTH: CGFloat = 225
    let VIEW_ITEM_HEIGHT: CGFloat = 282
    let carousels_margin_top: CGFloat = 10
    let carousels_padding: CGFloat = 0
    let carousels_height: CGFloat = 330
    
    let enableMultipleCarousels: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, chooseGameCompleted: (([GameModel]) -> Void)?) {
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
        guard let pref = preferences else {
            return
        }
        
        selectedConsoles = pref
        
        if pref.count > 0 {
            nextButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: isNavBar!)
        nextButton.isEnabled = false
        
        gameCarousel.bounceDistance = 0.3
        gameCarousel.scrollSpeed = 0.3
        
        carousels = [iCarousel]()
        carousels.append(gameCarousel)
        // Let's add carousels items
        let consoles = LocalDataManager.consolesSelected
        if let consoles = consoles {
            if consoles.count > 0 {
                let carousel = iCarousel(frame: CGRect(x: gameCarousel.frame.minX, y: gameCarousel.frame.maxY + 20, width: gameCarousel.frame.width, height: gameCarousel.frame.height))
                carousels.append(carousel)
            }
        }
        //carousels = [gameCarousel]
        
        getGames()
        
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCarouselItem(_:)), name: selectedCarouselItem, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addSelectedGames()
    }
    
    deinit {
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
        NotificationCenter.default.removeObserver(self, name: selectedCarouselItem, object: nil)
    }
    
    func didSelectCarouselItem(_ notification: NSNotification) {
        nextButton.isEnabled = indexSelectedItems.count > 0
        
        if let indexCarousel = notification.userInfo?["index"] as? Int {
            if let index = notification.userInfo?["index"] as? Int {
                let preference: PreferencesModel
                let gameModel: GameModel
                if selectedConsoles.count > 0 {
                    preference = selectedConsoles[indexCarousel]
                    selectedGames = preference.games!
                    if selectedGames.count > 0 {
                        gameModel = selectedGames[index]
                        if let indexObject = selectedGames.index(where: {$0 === gameModel}) {
                            selectedGames.remove(at: indexObject)
                        } else {
                            selectedGames.append(gameModel)
                        }
                    } else {
                        let game = games?[index]
                        let newGameModel = GameModel(id: game?.id, year: game?.year, name: game?.name, avatar: game?.avatar, thumbnail: game?.thumbnail, active: game?.active, createdAt: game?.createdAt, updatedAt: game?.updatedAt)
                        if let indexObject = selectedGames.index(where: {$0 === newGameModel}) {
                            selectedGames.remove(at: indexObject)
                        } else {
                            selectedGames.append(newGameModel)
                        }
                        
                        selectedConsoles[indexCarousel].games = selectedGames
                    }
                    
                }
                
                selectedGamesTable?.reloadData()
                
            }
        }
    }
    
    @IBAction func onNextButtonTouch(_ sender: Any) {
        var games = [GameModel]()
        for item in indexSelectedItems {
            let game = self.games?[item - 1]
            let gameModel = GameModel(id: game?.id, year: game?.year, name: game?.name, avatar: game?.avatar, thumbnail: game?.thumbnail, active: game?.active, createdAt: game?.createdAt, updatedAt: game?.updatedAt)
            games.append(gameModel)
        }
        
        LocalDataManager.gamesSelected = games
        chooseGameCompleted!(games)
    }
    
    private func addSelectedGames() {
        let selectedGameLabel = UILabel(frame: CGRect(x: 10.0, y: gameCarousel.frame.maxY + 40.0, width: Utils.screenViewFrame().size.width, height: 20.0))
        selectedGameLabel.text = "JUEGOS SELECCIONADOS:"
        selectedGameLabel.font = UIFont().bebasBoldFont(size: 20.0)
        selectedGameLabel.textColor = UIColor.white
        selectedGameLabel.textAlignment = .left
        
        let selectedGamesTableFrame = CGRect(x: 0, y: selectedGameLabel.frame.maxY + 10.0, width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height - selectedGameLabel.frame.maxY + 10.0)
        selectedGamesTable = UITableView(frame: selectedGamesTableFrame)
        selectedGamesTable?.delegate = self
        selectedGamesTable?.dataSource = self
        selectedGamesTable?.isScrollEnabled = false
        selectedGamesTable?.separatorStyle = .none
        selectedGamesTable?.backgroundColor = UIColor.clear
        selectedGamesTable?.clipsToBounds = false
        
        view.insertSubview(selectedGameLabel, belowSubview: nextButton)
        view.insertSubview(selectedGamesTable!, belowSubview: nextButton)
    }
    
    private func getGames() {
        if let games: [Game] = ConfigurationParametersModel.games {
            if games.count > 0 {
                if let consoles = LocalDataManager.consolesSelected {
                    for index in stride(from: 0, to: consoles.count, by: 1) {
                        let carouselItems = configCarouselsItemsViews(games: games)
                        items.append(carouselItems)
                    }
                }
                
                self.games = games
            }
        }
        
        gameCarousel.type = .custom
        carouselsReloadData()
    }
    
    private func createCarousels(withItems: [Game]) {
        var carousels = [iCarousel]()
        var previousCarousel: iCarousel?
        let numberOfCarousels = (!enableMultipleCarousels) ? 1 : selectedConsoles.count
        for index in stride(from: 0, to: numberOfCarousels, by: 1) {
            if previousCarousel != nil {
                let carousel = iCarousel(frame: CGRect(x: 0, y: (previousCarousel?.frame.maxY)! + carousels_padding, width: Utils.screenViewFrame().width, height: carousels_height))
                carousel.type = .custom
                carousel.delegate = self
                carousel.dataSource = self
                carousel.bounceDistance = 0.3
                carousel.scrollSpeed = 0.3
                carousel.tag = index
                let viewItems: [UIView] = configCarouselsItemsViews(games: withItems)
                items[carousel.tag] = viewItems
                
                previousCarousel = carousel
                carousels.append(carousel)
                scrollView?.addSubview(carousel)
            } else {
                let carousel = iCarousel(frame: CGRect(x: 0, y: carousels_margin_top, width: Utils.screenViewFrame().width, height: carousels_height))
                carousel.type = .custom
                carousel.delegate = self
                carousel.dataSource = self
                carousel.bounceDistance = 0.3
                carousel.scrollSpeed = 0.3
                carousel.tag = index
                let viewItems: [UIView] = configCarouselsItemsViews(games: withItems)
                items[carousel.tag] = viewItems
                
                previousCarousel = carousel
                carousels.append(carousel)
                scrollView?.addSubview(carousel)
            }
        }
        
        self.carousels = carousels
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
        if selectedGames.count > 0 {
            return selectedGames.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let game = selectedGames[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont().bebasFont(size: 18.0)
        cell.textLabel?.text = "\(game.name ?? "")"
        
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
