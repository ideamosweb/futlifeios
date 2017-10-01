//
//  ChooseConsoleViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/25/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import AlamofireImage

class ChooseConsoleViewController: CarouselViewController {
    @IBOutlet weak var consoleCarousel: iCarousel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var chooseConsoleLAbel: UILabel!
    @IBOutlet weak var chooseMoreThanOneLable: UILabel!
    
    var consoles: [Console]?
    var selectedConsolesTable: UITableView?
    var isNavBar: Bool?
    var chooseConsoleCompleted: (([ConsoleModel]) -> Void)?
    
    let VIEW_ITEM_WIDTH: CGFloat = 240
    let VIEW_ITEM_HEIGHT: CGFloat = 220
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool, chooseConsoleCompleted: (([ConsoleModel]) -> Void)?) {
        self.chooseConsoleCompleted = chooseConsoleCompleted
        super.init(nibName: "ChooseConsoleViewController", bundle: Bundle.main)
        isNavBar = navBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseConsoleLAbel.font = UIFont().bebasBoldFont(size: 38)
        chooseMoreThanOneLable.font = UIFont().bebasFont(size: 18)
        
        nextButton.isEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: isNavBar!)
        
        consoleCarousel.bounceDistance = 0.3
        consoleCarousel.scrollSpeed = 0.3
        
        // Let's add carousels items
        carousels = [consoleCarousel]
        
        getConsoles()
        
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCarouselItem(_:)), name: selectedCarouselItem, object: nil)
        
        // Check if there selected consoles
        let consolesSelected = LocalDataManager.consolesSelected
        guard let consolesSel = consolesSelected else {
            return
        }
        
        if consolesSel.count > 0 {
            var index = 0
            for console: Console in consoles! {
                for consoleSel: ConsoleModel in consolesSel {
                    if console.id == consoleSel.id {
                        selectedItems.append(index)
                    }
                }
                
                index += 1
            }
            
            carouselsReloadData()
            nextButton.isEnabled = true
        }
        
        addSelectedConsoles()
        
        selectedConsolesTable?.reloadData()
    }
    
    deinit {
        let selectedCarouselItem = Notification.Name(Constants.kDidSelectCarouselItemNotification)
        NotificationCenter.default.removeObserver(self, name: selectedCarouselItem, object: nil)
    }
    
    func didSelectCarouselItem(_ notification: NSNotification) {
        if indexSelectedItems.count > 0 {
            nextButton.isEnabled = true
            selectedConsolesTable?.isHidden = false
            
        } else {
            selectedConsolesTable?.isHidden = true
        }
        
        selectedConsolesTable?.reloadData()
    }
    
    @IBAction func onNextButtonTouch(_ sender: Any) {
        var consoles = [ConsoleModel]()
        for item in indexSelectedItems {
            let console = self.consoles?[item - 1]
            let consoleModel = ConsoleModel(id: console?.id, platformId: console?.platformId, year: console?.year, name: console?.name, avatar: console?.avatar, thumbnail: console?.thumbnail, active: console?.active, createdAt: console?.createdAt, updatedAt: console?.updatedAt)
            
            consoles.append(consoleModel)
        }
        
        LocalDataManager.consolesSelected = consoles
        //LocalDataManager.user?.preferences = preferences
        chooseConsoleCompleted!(consoles)
    }
    
    private func addSelectedConsoles() {
        if selectedConsolesTable == nil {
            let selectedConsolesLabel = UILabel(frame: CGRect(x: 10.0, y: consoleCarousel.frame.maxY + 40.0, width: Utils.screenViewFrame().size.width, height: 20.0))
            selectedConsolesLabel.text = "CONSOLAS SELECCIONADAS:"
            selectedConsolesLabel.font = UIFont().bebasBoldFont(size: 20.0)
            selectedConsolesLabel.textColor = UIColor.white
            selectedConsolesLabel.textAlignment = .left
            
            let selectedConsolesTableFrame = CGRect(x: 0, y: selectedConsolesLabel.frame.maxY + 10.0, width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height - selectedConsolesLabel.frame.maxY + 10.0)
            selectedConsolesTable = UITableView(frame: selectedConsolesTableFrame)
            selectedConsolesTable?.delegate = self
            selectedConsolesTable?.dataSource = self
            selectedConsolesTable?.isScrollEnabled = false
            selectedConsolesTable?.separatorStyle = .none
            selectedConsolesTable?.backgroundColor = UIColor.clear
            selectedConsolesTable?.clipsToBounds = false
            
            view.insertSubview(selectedConsolesLabel, belowSubview: nextButton)
            view.insertSubview(selectedConsolesTable!, belowSubview: nextButton)
        }
    }
    
    private func getConsoles() {       
        if let consoles: [Console] = ConfigurationParametersModel.consoles {
            if consoles.count > 0 {
                let carouselItems = configCarouselsItemsViews(consoles: consoles)
                items.append(carouselItems)
                self.consoles = consoles
            }
        }
        
        consoleCarousel.type = .custom
        carouselsReloadData()
    }
    
    private func configCarouselsItemsViews(consoles: [Console]) -> [UIView] {
        var carouselItemsViews = [UIImageView]()
        let preferences = LocalDataManager.user?.preferences
        
        var index = 0
        for console in consoles {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: VIEW_ITEM_WIDTH, height: VIEW_ITEM_HEIGHT))
            let imageUrl = URL(string: console.avatar!)!
            let placeholderImage = UIImage(named: "loading_console")!
            
            imageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
            
            if let preferences = preferences {
                for preference in preferences {
                    if preference.consoleId == "\(console.id ?? 0)" {
                        // Set yellow shadow to itemView
                        imageView.layer.shadowColor = UIColor.yellow.cgColor
                        imageView.layer.shadowOpacity = 1
                        imageView.layer.shadowOffset = CGSize.zero
                        imageView.layer.shadowRadius = 10
                        
                        indexSelectedItems.append(index + 1)
                        selectedItems.append(index)
                    }
                }
            }
            
            carouselItemsViews.append(imageView)
            index += 1
        }
        
        return carouselItemsViews
    }
}

// MARK:  UITableViewDelegate methods
extension ChooseConsoleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}

// MARK: UITableViewDataSource methods
extension ChooseConsoleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexSelectedItems.count > 0 {
            return indexSelectedItems.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont().bebasFont(size: 18.0)
        cell.isUserInteractionEnabled = false
        
        let console = consoles?[indexSelectedItems[indexPath.row] - 1]
        cell.textLabel?.text = console?.name
        
        return cell
    }
}
