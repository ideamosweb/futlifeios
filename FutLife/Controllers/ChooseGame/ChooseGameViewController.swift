//
//  ChooseGameViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/29/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChooseGameViewController: CarouselViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var gameCarousel: iCarousel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var chooseGameLabel: UILabel!
    @IBOutlet weak var chooseMoreThanOneLable: UILabel!
    
    var games: [Game]?
    var selectedGames = [Game]()
    var selectedGamesTable: UITableView?
    var isNavBar: Bool?
    var chooseGameCompleted: ([GameModel]) -> Void?
    
    let VIEW_ITEM_WIDTH: CGFloat = 225
    let VIEW_ITEM_HEIGHT: CGFloat = 282
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, chooseGameCompleted: @escaping ([GameModel]) -> Void?) {
        self.chooseGameCompleted = chooseGameCompleted
        super.init(nibName: "ChooseGameViewController", bundle: Bundle.main)
        isNavBar = navBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseGameLabel.font = UIFont().bebasBoldFont(size: 38)
        chooseMoreThanOneLable.font = UIFont().bebasFont(size: 18)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar(show: isNavBar!)
        nextButton.isEnabled = false
        
        gameCarousel.bounceDistance = 0.3
        gameCarousel.scrollSpeed = 0.3
        
        // Let's add carousels items
        carousels = [gameCarousel]
        
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
        
        if let index = notification.userInfo?["index"] as? Int {
            let game: Game = games![index]
            
            
            if let indexObject = selectedGames.index(where: {$0 === game}) {
                selectedGames.remove(at: indexObject)
            } else {
                selectedGames.append(game)
            }
            
            selectedGamesTable?.reloadData()
            
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
        chooseGameCompleted(games)
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
                let carouselItems = configCarouselsItemsViews(games: games)
                items.append(carouselItems)
                self.games = games
            }
        }
        
        gameCarousel.type = .custom
        carouselsReloadData()
    }
    
    private func configCarouselsItemsViews(games: [Game]) -> [UIView] {
        var carouselItemsViews = [UIImageView]()
        for game in games {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: VIEW_ITEM_WIDTH, height: VIEW_ITEM_HEIGHT))
            let imageUrl = URL(string: game.avatar!)!
            let placeholderImage = UIImage(named: "loading_placeholder")!
            
            imageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
            
            carouselItemsViews.append(imageView)
        }
        
        return carouselItemsViews
    }
    
    // MARK:  UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedGames.count > 0 {
            return selectedGames.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
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
