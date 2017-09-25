//
//  ChallengesViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChallengesViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noNotiLabel: UILabel!
    var players: [User]?
    var challenges: [Challenges]?
    let kChallengesCellHeight: CGFloat = 84.0
    let kChallengesCellIdentifier = "ChallengesCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [User]?, challenges: [Challenges]?) {
        self.players = players
        self.challenges = challenges!
        super.init(nibName: "ChallengesViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ChallengesCell.nib(kChallengesCellIdentifier), forCellReuseIdentifier: kChallengesCellIdentifier)
        
        var hidden = true
        if let challenges = challenges {
            hidden = (challenges.count > 0)
        }
        
        noNotiLabel.isHidden = hidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.layoutSubviews()
    }
}

//MARK: UITableViewDelegate
extension ChallengesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kChallengesCellHeight
    }
}

//MARK: UITableViewDataSource
extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let challenges = challenges {
            return challenges.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChallengesCell = tableView.dequeueReusableCell(withIdentifier: kChallengesCellIdentifier) as! ChallengesCell
        if let challenges = challenges {
            let challenge = challenges[indexPath.row]
            cell.setUpView(challenge: challenge, players: players)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
