//
//  ChooseConsoleViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/25/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChooseConsoleViewController: CarouselViewController {
    @IBOutlet weak var consoleCarousel: iCarousel!
    @IBOutlet weak var nextButton: UIButton!
    
    var consoles: [AnyObject]?
    var selectedConsoles: [AnyObject]?
    var selectedConsolesTable: UITableView?
    var isNavBar: Bool?
    var carouselView: iCarousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 375, height: 240))
    
    let VIEW_ITEM_WIDTH: CGFloat = 240
    let VIEW_ITEM_HEIGHT: CGFloat = 220
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navBar: Bool) {
        super.init(nibName: "ChooseConsoleViewController", bundle: Bundle.main)
        isNavBar = navBar
    }

    override func viewDidLoad() {
        consoleCarousel.type = .linear
        super.viewDidLoad()

        showNavigationBar(show: isNavBar!)
        nextButton.isEnabled = false
        
        consoleCarousel.bounceDistance = 0.3
        consoleCarousel.scrollSpeed = 0.3
        
        carousels = [consoleCarousel]
        
        getConsoles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    private func getConsoles() {
        var carouselItems = [UIView]()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240.0, height: 220.0))
        view.backgroundColor = UIColor.red
        
        carouselItems.append(view)
        items.append(carouselItems)
        
        
        if let consoles: [Console] = ConfigurationParametersModel.consoles {
            if consoles.count > 0 {
                
            }
        }
        
        carouselsReloadData()
    }
    
    private func configCarouselsItemsViews(consoles: [Console]) -> [UIView] {
        return [UIView]()
    }
    
    private func addSelectedConsoles() {
        
    }
}
