//
//  PlayersListViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayersListViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var players: [User]
    let kPlayersCellIdentifier = "PlayersListCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [User]) {
        self.players = players
        super.init(nibName: "PlayersListViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar(show: true)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationBar(show: true)
        parent?.navigationController?.navigationBar.barTintColor = UIColor().darkBlue()
        parent?.navigationController?.navigationBar.isTranslucent = true
        
        let dataSource = PlayersListDataSource(players: players)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        
        tableView.register(PlayersListCell.nib(kPlayersCellIdentifier), forCellReuseIdentifier: kPlayersCellIdentifier)
        tableView.contentOffset = CGPoint(x: 0.0, y: 88.0)
        tableView.layoutSubviews()
    }
}
