//
//  PlayerStatisticsViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

enum StatisticsCell: Int {
    case latest = 0
    case points = 1
    case graph = 2
}

class PlayerStatisticsViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    let statisticsCells: [StatisticsCell] = [StatisticsCell.latest, StatisticsCell.points, StatisticsCell.graph]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "PlayerStatisticsViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PlayerStatisticsLatestCell.nib("PlayerStatisticsLatestCell"), forCellReuseIdentifier: "PlayerStatisticsLatestCell")
        tableView.register(PlayerStatisticsPointsCell.nib("PlayerStatisticsPointsCell"), forCellReuseIdentifier: "PlayerStatisticsPointsCell")
        tableView.register(PlayerStatisticsGraphCell.nib("PlayerStatisticsGraphCell"), forCellReuseIdentifier: "PlayerStatisticsGraphCell")
    }
    
    func developViewLb() {
        let label = UILabel(frame: CGRect(x: 20, y: 30, width: Utils.screenViewFrame().width - 40, height: 22))
        label.font = UIFont().bebasFont(size: 20)
        label.text = "Funcionalidad en desarrollo"
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        view.addSubview(label)
    }
}

extension PlayerStatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statisticCell = statisticsCells[indexPath.row]
        switch statisticCell {
        case .latest:
            return 100.0
        case .points:
            return 70.0
        case .graph:
            return 200.0
        }
    }
}

extension PlayerStatisticsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let statisticCell = statisticsCells[indexPath.row]
        switch statisticCell {
        case .latest:
            let latestCell: PlayerStatisticsLatestCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatisticsLatestCell") as! PlayerStatisticsLatestCell
            latestCell.setUpView()
            
            cell = latestCell
        case .points:
            let pointsCell: PlayerStatisticsPointsCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatisticsPointsCell") as! PlayerStatisticsPointsCell
            pointsCell.setUpView()
            
            cell = pointsCell
        case .graph:
            let graphCell: PlayerStatisticsGraphCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatisticsGraphCell") as! PlayerStatisticsGraphCell
            cell = graphCell
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
}
