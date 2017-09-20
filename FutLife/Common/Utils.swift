//
//  Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func addBorderColor(view: UIView, color: UIColor, roundSize: CGFloat, stroke: CGFloat) {
        view.layer.cornerRadius = roundSize
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = stroke
        view.clipsToBounds = true
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func screenViewFrame() -> CGRect {
        let viewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height)
        
        return viewFrame
    }
    
    class func setAvatar(imageView: UIImageView) {
        let placeholderImage = UIImage(named: "avatar_placeholder")!
        if let avatar = LocalDataManager.avatar {
            imageView.image = avatar
        } else {
            if let userAvatar = LocalDataManager.user?.avatar, !userAvatar.isEmpty  {
                imageView.af_setImage(withURL: URL(string: userAvatar)!, placeholderImage: placeholderImage)
            } else {
                imageView.image = placeholderImage
            }
        }
    }
    
    class func savePreferencesModel(preferences: [Preferences]?) -> [PreferencesModel] {
        var preferencesModel: [PreferencesModel] = []
        
        if let preferences = preferences {
            for preference: Preferences in preferences {
                let consoleModel: ConsoleModel = ConsoleModel(id: preference.console?.id, platformId: preference.console?.platformId, year: preference.console?.year, name: preference.console?.name, avatar: preference.console?.avatar, thumbnail: preference.console?.thumbnail, active: preference.console?.active, createdAt: preference.console?.createdAt, updatedAt: preference.console?.updatedAt)
                
                let gamesModel = Utils.saveGamesModel(games: preference.games)
                let prefId: Int = preference.id!
                let preferenceModel: PreferencesModel = PreferencesModel(id: prefId, userId: preference.userId, consoleId: preference.consoleId, playerId: preference.playerId, active: preference.active, console: consoleModel, games: gamesModel)
                preferencesModel.append(preferenceModel)
            }
        }
        
        return preferencesModel
    }
    
    class func saveConsolesModel(consoles: [Console]?) -> [ConsoleModel] {
        var consolesModel: [ConsoleModel] = []
        if let consoles = consoles {
            for console in consoles {
                let consoleModel: ConsoleModel = ConsoleModel(id: console.id, platformId: console.platformId, year: console.year, name: console.name, avatar: console.avatar, thumbnail: console.thumbnail, active: console.active, createdAt: console.createdAt, updatedAt: console.updatedAt)
                consolesModel.append(consoleModel)
            }
        }
        
        return consolesModel
        
    }
    
    class func saveGamesModel(games: [Game]?) -> [GameModel] {
        var gamesModel: [GameModel] = []
        if let games = games {
            for game in games {
                let gameModel = GameModel(id: game.id, year: game.year, name: game.name, avatar: game.avatar, thumbnail: game.thumbnail, active: game.active, createdAt: game.createdAt, updatedAt: game.updatedAt)
                gamesModel.append(gameModel)
            }
        }
        
        return gamesModel
    }
    
    class func retrieveConsoles() -> [ConsoleModel] {
        var consolesSelected: [ConsoleModel] = []
        if let preferences = LocalDataManager.user?.preferences {
            for preference: PreferencesModel in preferences {
                if let console = preference.console {
                    consolesSelected.append(console)
                }
            }
        }
        
        return consolesSelected
    }
    
    class func retrieveGames() -> [GameModel] {
        var gamesSelected: [GameModel] = []
        if let preferences = LocalDataManager.user?.preferences {
            for preference: PreferencesModel in preferences {
                if let games = preference.games {
                    gamesSelected = games
                }
            }
        }
        
        return gamesSelected
    }
}
