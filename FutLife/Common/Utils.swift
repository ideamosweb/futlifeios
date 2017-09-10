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
}
