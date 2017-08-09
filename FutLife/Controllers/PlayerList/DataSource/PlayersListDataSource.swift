//
//  PlayersListDataSource.swift
//  FutLife
//
//  Created by Rene Santis on 8/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayersListDataSource: NSObject {
    let kPlayersCellHeight: CGFloat = 60.0;
    let kPlayersCellIdentifier = "PlayersListCell"
    let players: [User]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [User]) {
        self.players = players
        super.init()
    }
}

extension PlayersListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kPlayersCellHeight
    }
}

extension PlayersListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayersListCell = tableView.dequeueReusableCell(withIdentifier: kPlayersCellIdentifier) as! PlayersListCell
        let user = players[indexPath.row]
        cell.setUpCell(user: user)
        
        return cell
    }
    
}
