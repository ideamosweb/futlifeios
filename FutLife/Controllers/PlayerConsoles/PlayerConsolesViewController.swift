//
//  PlayerConsolesViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/11/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerConsolesViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var consoles: [ConsoleModel]?
    let kProfileCellIdentifier = "PlayerConsolesCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(consoles: [ConsoleModel]) {
        self.consoles = consoles
        super.init(nibName: "PlayerConsolesViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PlayerConsolesCell.nib(kProfileCellIdentifier), forCellReuseIdentifier: kProfileCellIdentifier)
    }
}

extension PlayerConsolesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

extension PlayerConsolesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (consoles?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: PlayerConsolesCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier) as! PlayerConsolesCell
        let console = consoles?[indexPath.row]
        
        profileCell.setGameImage(name: (console?.avatar)!, gameName: (console?.name)!)
        if let games: [GameModel] = LocalDataManager.gamesSelected {
            profileCell.setGames(games: games, width: profileCell.frame.width)
        }
        
        profileCell.isUserInteractionEnabled = false        
        
        return profileCell
    }
    
}
