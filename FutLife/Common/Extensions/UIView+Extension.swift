//
//  UIView+Extension.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension UIView {
    func fadeIn(duration: TimeInterval, closure: @escaping() -> Void?) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }) { (finished) in
            if closure() != nil {
                closure()
            }
        }
    }
    
    func fadeOut(duration: TimeInterval, closure: @escaping() -> Void?) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (finished) in
            if closure() != nil {
                closure()
            }
        }
    }
    
    func circularView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }
    
    func animateLogo() {
        let frame = self.frame
        let frameUp = CGRect(x: frame.origin.x - 20, y: frame.origin.y - 10, width: frame.size.width + 20, height: frame.size.height + 10)
        
        let options: UIViewAnimationOptions = [.beginFromCurrentState, .transitionFlipFromRight]
        layoutIfNeeded()
        
        fadeIn(duration: 0.5, closure: {()})
        
        UIView.transition(with: self, duration: 0.6, options: options, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: -1)
        }) { (finished) in
            UIView.transition(with: self, duration: 0.2, options: options, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 0.8)
            }, completion: { (finished) in
                UIView.transition(with: self, duration: 0.1, options: options, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.4, delay: 0.8, options: .layoutSubviews, animations: {
                        self.bounds = frameUp
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.bounds = frame
                        })
                    })
                })
            })
        }
    }
}
