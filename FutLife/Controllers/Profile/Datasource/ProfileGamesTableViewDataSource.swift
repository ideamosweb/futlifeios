//
//  ProfileGamesTableViewDataSource.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import UIKit

class ProfileGamesTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var selectedCellIndexPath: IndexPath?
    let kProfileCellHeight: CGFloat = 44.0;
    let kProfileCellConsolesHeight: CGFloat = 22.0;
    let kProfileCellIdentifier = "ProfileCell"
    override init() { }
    
    // MARK:  UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let games: [GameModel] = LocalDataManager.gamesSelected {
            return games.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath != nil && selectedCellIndexPath?.compare(indexPath) == ComparisonResult.orderedSame {
            // TODO: 
            //if let games: [GameModel] = LocalDataManager.gamesSelected {
                //let game = games[indexPath.row]
                return kProfileCellHeight + kProfileCellConsolesHeight
            //}
            
            //return kProfileCellHeight
        }
        
        return kProfileCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier) as! ProfileCell
        if let games: [GameModel] = LocalDataManager.gamesSelected {
            let game = games[indexPath.row]
            
            profileCell.setGameImage(name: game.avatar, gameName: game.name, gameYear: game.year as NSNumber, gameNumber: "\(indexPath.row + 1)")
            profileCell.isUserInteractionEnabled = false
        }
        
        return profileCell
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if selectedCellIndexPath != nil {
//            if selectedCellIndexPath?.compare(indexPath) == ComparisonResult.orderedSame {
//                selectedCellIndexPath = nil
//                tableView.cellForRow(at: indexPath)?.isSelected = false
//                tableView.reloadRows(at: [indexPath], with: .none)
//                return nil
//            } else {
//                tableView.reloadRows(at: [selectedCellIndexPath!], with: .none)
//            }
//        } else {
//            selectedCellIndexPath = indexPath
//            tableView.reloadRows(at: [selectedCellIndexPath!], with: .none)
//        }
//        
//        return indexPath
//    }   
    
}
