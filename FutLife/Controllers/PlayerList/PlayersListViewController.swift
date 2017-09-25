//
//  PlayersListViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayersListViewController: ViewController {
    let kPlayersCellHeight: CGFloat = 80.0;
    let kPlayersCellIdentifier = "PlayersListCell"
    
    @IBOutlet weak var tableView: UITableView!    
    
    var players: [User]?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [User]?) {
        self.players = players
        super.init(nibName: "PlayersListViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayersListCell.nib(kPlayersCellIdentifier), forCellReuseIdentifier: kPlayersCellIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.layoutSubviews()
    }
}

//MARK: UITableViewDelegate
extension PlayersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kPlayersCellHeight
    }
}

//MARK: UITableViewDataSource
extension PlayersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = players {
            return players.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayersListCell = tableView.dequeueReusableCell(withIdentifier: kPlayersCellIdentifier) as! PlayersListCell
        if let players = players {
            let user = players[indexPath.row]
            cell.delegate = parent as! HomeViewController
            cell.setUpCell(user: user)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
