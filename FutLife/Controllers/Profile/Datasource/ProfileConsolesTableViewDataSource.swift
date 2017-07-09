//
//  ProfileConsolesTableViewDataSource.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import UIKit

class ProfileConsolesTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var selectedCellIndexPath: IndexPath?
    let kProfileCellHeight: CGFloat = 44.0;
    let kProfileCellIdentifier = "ProfileCell"
    override init() { }
    
    // MARK:  UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let consoles: [ConsoleModel] = LocalDataManager.consolesSelected {
            return consoles.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {       
        return kProfileCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier) as! ProfileCell
        if let consoles: [ConsoleModel] = LocalDataManager.consolesSelected {
            let console = consoles[indexPath.row]
            
            profileCell.setGameImage(name: console.avatar, gameName: console.name, gameYear: console.year as NSNumber, gameNumber: "\(indexPath.row + 1)")
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
