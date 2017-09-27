//
//  CarouselViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class CarouselViewController: ViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet weak var topOnstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var carousels: [iCarousel]!
    var carouselType: iCarouselType?
    var items = [[UIView]]()
    var selectedItems = [Int]()
    var indexSelectedItems = [Int]()
    var contentView: UIView?    
    
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
    
    func checkSelected(item: Int) -> Bool {
        if ((selectedItems.index(where: {$0 == item})) != nil) {
            return false
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
            return itemView
        }
        
        itemView = view
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let itemView = carousel.itemView(at: index)
        if checkSelected(item: index) {
            // Set yellow shadow to itemView
            itemView?.layer.shadowColor = UIColor.yellow.cgColor
            itemView?.layer.shadowOpacity = 1
            itemView?.layer.shadowOffset = CGSize.zero
            itemView?.layer.shadowRadius = 10
            
            indexSelectedItems.append(index + 1)
            selectedItems.append(index)
        } else {
            // Back to "normal" state
            itemView?.layer.shadowColor = UIColor.clear.cgColor
            itemView?.layer.shadowOpacity = 1
            itemView?.layer.shadowOffset = CGSize.zero
            itemView?.layer.shadowRadius = 0
            
            selectedItems.remove(object: index)
            indexSelectedItems.remove(object: index + 1)
        }
        
        // Post notification to notify selection of an item
        let itemSelected: [String: Int] = ["index": index, "carousel": carousel.tag]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kDidSelectCarouselItemNotification), object: nil, userInfo: itemSelected)
        
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
