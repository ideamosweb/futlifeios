//
//  NavMenuViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class NavMenuViewController: ViewController {
    let kHeightForHeaderSections = 44.0
    let kResuseIdentifierCell = "NavMainMenuCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var player: UserModel
    var menuItems: Dictionary<String, Any>? //Dictionary
    var items: [Dictionary<String, Any>]? //Array
    var navMenuDatasource: NSDictionary!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: UserModel, menuItems: Dictionary<String, Any>?) {
        self.player = player
        self.menuItems = menuItems
        self.items = menuItems?["Menu"] as? [Dictionary<String, Any>]
        super.init(nibName: "NavMenuViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLb.text = player.userName
        emailLb.text = player.email
        
        avatar.circularView()
        let placeholderImage = UIImage(named: "loading_placeholder")!
        
        if (player.avatar != "") {
            avatar.af_setImage(withURL: URL(string: player.avatar)!, placeholderImage: placeholderImage)
        } else {
            avatar.image = placeholderImage
        }
        
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.autoresizesSubviews = true
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
}

//MARK: UITableViewDelegate
extension NavMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: UITableViewDataSource
extension NavMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let menuItems = menuItems else {
            return 0
        }
        
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {
            return 0
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kHeightForHeaderSections)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let keys = Array(menuItems!.keys)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(kHeightForHeaderSections)))
        headerView.backgroundColor = UIColor(red: 2.0/255.0, green: 14.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        let headerText = keys[section]
        let titleLabel = UILabel(frame: CGRect(x: 10.0, y: 5.0, width: tableView.frame.width - 10, height: CGFloat(kHeightForHeaderSections) - 5))
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        titleLabel.backgroundColor = UIColor(red: 2.0/255.0, green: 14.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.text = headerText
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(red: 2.0/255.0, green: 14.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        
        let itemDict = items?[indexPath.row]
        if let text = itemDict?["title"] {
            cell.textLabel?.text = text as? String
        }
        
        if let image = itemDict?["slidingMenuImage"] {
            let imageName = image as? String
            cell.imageView?.image = UIImage(named: imageName!)
        }
        
        return cell
    }
}
