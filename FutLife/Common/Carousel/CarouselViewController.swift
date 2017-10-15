//
//  CarouselViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
enum CarouselSource {
    case consoles
    case games
}

class CarouselViewController: ViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet weak var topOnstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var carousels: [iCarousel]!
    var carouselType: iCarouselType?
    var items = [[UIView]]()
    var selectedItems = [Int]()
    var indexSelectedItems = [[Int]]()
    var selectedItemsRecorded: [[Bool]]?
    var contentView: UIView?
    var carouselSource: CarouselSource?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setScrollContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustLayout()
    }
    
    // MARK: Public methods
    public func carouselsReloadData() {
        for carousel: iCarousel in carousels {
            carousel.reloadData()
        }
    }
    
    // MARK: Private methods
    private func adjustLayout() {
        if carousels.count > 1 {
            topOnstraint.constant = 50
        }
    }
    
    private func setScrollContentSize() {
        if carousels.count > 1 {
            let lastView = carousels.last
            let maxY: CGFloat = scrollView!.convert((lastView?.frame)!, to: lastView?.superview).maxY
            
            scrollView?.contentSize = CGSize(width: (scrollView?.frame.width)!, height: maxY)
        }
    }
    
    private func getCurrentCarousel(from carousel: iCarousel) -> iCarousel? {
        guard let carousels = carousels else {
            return nil
        }
        
        for carouselAdded in carousels {
            if carouselAdded == carousel {
                return carouselAdded
            }
        }
        
        return nil
    }
    
    func checkSelected(item: Int, carousel: Int) -> Bool {
        if indexSelectedItems.count > 0 {
            let items = indexSelectedItems[carousel]
            if ((items.index(where: {$0 == item})) != nil) {
                return false
            }
        }        
        
        return true
    }
    
    // MARK: iCarousel methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        let currentCarousel = getCurrentCarousel(from: carousel)
        
        guard let current = currentCarousel else {
            return 1
        }
        
        return items[current.tag].count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        let currentCarousel = getCurrentCarousel(from: carousel)
        
        guard let current = currentCarousel else {
            return view!
        }        
        
        guard let view = view else {
            itemView = items[current.tag][index]
            if let selectedItemsRec = selectedItemsRecorded {
                if selectedItemsRec[current.tag].count > 0 {
                    if selectedItemsRec[current.tag][index] {
                        // Set yellow shadow to itemView
                        itemView.layer.shadowColor = UIColor.yellow.cgColor
                        itemView.layer.shadowOpacity = 1
                        itemView.layer.shadowOffset = CGSize.zero
                        itemView.layer.shadowRadius = 10
                    }
                }
            }
            
            return itemView
        }
        
        itemView = view
        if (selectedItemsRecorded?.count)! > 0 {
            if (selectedItemsRecorded?[current.tag][index])! {
                // Set yellow shadow to itemView
                itemView.layer.shadowColor = UIColor.yellow.cgColor
                itemView.layer.shadowOpacity = 1
                itemView.layer.shadowOffset = CGSize.zero
                itemView.layer.shadowRadius = 10
            }
            
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let itemView = carousel.itemView(at: index)
        let isSelected: Bool
        if checkSelected(item: index, carousel: carousel.tag) {
            // Set yellow shadow to itemView
            itemView?.layer.shadowColor = UIColor.yellow.cgColor
            itemView?.layer.shadowOpacity = 1
            itemView?.layer.shadowOffset = CGSize.zero
            itemView?.layer.shadowRadius = 10
            
            indexSelectedItems[carousel.tag].append(index)
            selectedItems.append(index)
            isSelected = true
        } else {
            // Back to "normal" state
            itemView?.layer.shadowColor = UIColor.clear.cgColor
            itemView?.layer.shadowOpacity = 1
            itemView?.layer.shadowOffset = CGSize.zero
            itemView?.layer.shadowRadius = 0
            
            selectedItems.remove(object: index)
            indexSelectedItems[carousel.tag].remove(object: index)
            isSelected = false
        }
        
        // Post notification to notify selection of an item
        let itemSelected: [String: Int] = ["index": index, "carousel": carousel.tag, "isSelected": Int(NSNumber(value: isSelected))]
        if indexSelectedItems.count > 1 {
            if let crslSource = carouselSource {
                if crslSource == .games {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDidSelectCarouselsItemNotification), object: nil, userInfo: itemSelected)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDidSelectCarouselItemNotification), object: nil, userInfo: itemSelected)
                }
            }            
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .spacing:
            return value * 1.1
        
        default:
            return value
        }
    }
    
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        // Custom transform for expected behaviour
        // https://stackoverflow.com/a/39033533
        // For each item view.
        
        let offsetFactor = self.carousel(carousel, valueFor: iCarouselOption.spacing, withDefault: 1) * carousel.itemWidth
        
        let zFactor: CGFloat = 100
        let normalFactor: CGFloat = 0
        let shrinkFactor: CGFloat = 3.0
        let f = sqrt(offset * offset + 1) - 1
        
        var transform = CATransform3DTranslate(transform, offset * offsetFactor, f * normalFactor, f * (-zFactor));
        transform = CATransform3DScale(transform, 1 / (f / shrinkFactor + 1), 1 / (f / shrinkFactor + 1), 1);
        return transform;
        
    }
}
