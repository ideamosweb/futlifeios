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
    
    var carousels: [iCarousel]!
    var carouselType: iCarouselType?
    var items = [[UIView]]()
    var selectedItems: [AnyObject]?
    var indexSelectedItems: [AnyObject]?
    var scrollView: UIScrollView?
    var contentView: UIView?    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setScrollContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustLayout()
    }
    
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
    
    // MARK: Public methods
    public func carouselsReloadData() {
        for carousel: iCarousel in carousels {
            carousel.reloadData()
        }
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
}
