//
//  TabsViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/6/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class TabsViewController: ViewController {
    
    let kTabsButtonsViewHeight: CGFloat = 44.0
    
    var tabsButtonsViewMinY: CGFloat = 0.0
    var scrollToPage: Int = 0
    var previousOffset: CGFloat = 0
    var tabsViewControllers: [ViewController]?
    var tabsViews: [UIView] = []
    var tabsTitles: [String] = []
    var fontSize: CGFloat?
    var showTabDefault: Int?
    var selectorTabButtonView: UIView?
    var tabsBellowView: UIView?
    var insertInView: UIView?
    var useDefaultViewHeight: Bool = false
    
    private var scrollView: UIScrollView?
    var buttonsView: UIView?
    
    var tabsCount: Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
    }
    
    func configElementsOfView() {
        let scrollViewHeight = (!useDefaultViewHeight) ? Utils.screenViewFrame().size.height - tabsButtonsViewMinY - kTabsButtonsViewHeight : Utils.screenViewFrame().size.height
        
        buttonsView?.backgroundColor = UIColor().darkBlue()
        selectorTabButtonView = UIView(frame: CGRect(x: 0.0, y: (buttonsView?.frame.height)! - 2.0, width: (buttonsView?.frame.width)! / CGFloat(tabsCount!), height: 2.0))
        selectorTabButtonView?.backgroundColor = UIColor().greenDefault()
        buttonsView?.addSubview(selectorTabButtonView!)
        
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: (buttonsView?.frame.maxY)!, width: Utils.screenViewFrame().size.width, height: scrollViewHeight))
        scrollView?.delegate = self
        
        if let insertView = insertInView {
            insertView.addSubview(scrollView!)
            insertView.addSubview(buttonsView!)            
        } else {
            view.addSubview(scrollView!)
            view.addSubview(buttonsView!)
        }
        
    }
    
    func reloadTabs() {
        tabsCount = ((tabsViewControllers?.count)! > 0) ? Float((tabsViewControllers?.count)!) : Float(tabsViews.count)
        let buttonWidth = Utils.screenViewFrame().size.width / CGFloat(tabsCount!)
        
        // Check subviews for add tabs after
        var subViewFrame: CGRect?
        for subView: UIView in view.subviews {
            if subView.frame != view.frame {
                subViewFrame = subView.frame
            }
        }
        
        if let sbViewFr = subViewFrame {
            tabsButtonsViewMinY = sbViewFr.maxY
        }
        
        if let bellowSV = tabsBellowView {
            tabsButtonsViewMinY = bellowSV.frame.maxY
        }
        
        buttonsView = UIView(frame: CGRect(x: 0.0, y: tabsButtonsViewMinY, width: Utils.screenViewFrame().size.width, height: kTabsButtonsViewHeight))
        
        configElementsOfView()
        
        var previousButton: UIButton?
        var previousVC: ViewController?
        
        var contentSizeWidth: CGFloat = 0
        let contentSizeHeight = (!useDefaultViewHeight) ? Utils.screenViewFrame().size.height - tabsButtonsViewMinY - kTabsButtonsViewHeight : Utils.screenViewFrame().size.height
        
        let fontSize = (self.fontSize != nil) ? self.fontSize : 20.0
        
        for index in stride(from: 0, to: Int(tabsCount!), by: 1) {
            let buttonTab = UIButton()
            let tabTitle = ((tabsTitles.count) > 0) ? tabsTitles[index] : "Tab \(index + 1)"
            
            if previousButton == nil {
                buttonTab.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: 44.0)
                
                buttonTab.titleLabel?.font = UIFont().bebasBoldFont(size: fontSize!)
                buttonTab.setTitleColor(UIColor.lightGray, for: .normal)
                buttonTab.setTitle(tabTitle, for: .normal)
                buttonTab.contentHorizontalAlignment = .center
                buttonTab.tag = index + 1
                
                let separator = UIView(frame: CGRect(x: buttonTab.frame.width - 1, y: (buttonTab.frame.height / 2) / 2, width: 1.0, height: 20.0))
                separator.backgroundColor = UIColor(red: 60.0, green: 143.0, blue: 130.0, alpha: 1.0)
                
                buttonTab.addSubview(separator)
                
                previousButton = buttonTab
            } else {
                buttonTab.frame = CGRect(x: (previousButton?.frame.maxX)!, y: 0.0, width: buttonWidth, height: 44.0)
                
                buttonTab.titleLabel?.font = UIFont().bebasBoldFont(size: fontSize!)
                buttonTab.setTitleColor(UIColor.lightGray, for: .normal)
                buttonTab.setTitle(tabTitle, for: .normal)
                buttonTab.contentHorizontalAlignment = .center
                buttonTab.tag = index + 1
                
                if (index + 1) < Int(tabsCount!) {
                    let separator = UIView(frame: CGRect(x: buttonTab.frame.width - 1, y: (buttonTab.frame.height / 2) / 2, width: 1.0, height: 20.0))
                    separator.backgroundColor = UIColor(red: 60.0, green: 143.0, blue: 130.0, alpha: 1.0)
                    
                    buttonTab.addSubview(separator)
                }
                
                previousButton = buttonTab
            }
            
            buttonTab.addTarget(self, action: #selector(onButtonTabTouch), for: .touchUpInside)
            
            buttonsView?.addSubview(buttonTab)
            
            contentSizeWidth = Utils.screenViewFrame().size.width * (CGFloat(index) + 1)
            
            if (tabsViewControllers?.count)! > 0 {
                let viewController = tabsViewControllers?[index]
                var tabsFrame = viewController?.view.frame
                
                if previousVC == nil {
                    tabsFrame?.size.width = Utils.screenViewFrame().size.width
                    tabsFrame?.size.height = Utils.screenViewFrame().size.height - CGFloat(kTabsButtonsViewHeight) - CGFloat(Constants.kNavigationBarDefaultHeight)
                    viewController?.view.frame = tabsFrame!
                } else {
                    var vcFrame = viewController?.view.frame
                    vcFrame?.origin.x = (previousVC?.view.frame.maxX)!
                    vcFrame?.size.width = Utils.screenViewFrame().size.width
                    vcFrame?.size.height = Utils.screenViewFrame().size.height - CGFloat(kTabsButtonsViewHeight) - CGFloat(Constants.kNavigationBarDefaultHeight)
                    viewController?.view.frame = vcFrame!
                }
                
                previousVC = viewController
                
                addChildViewController(viewController!)
                scrollView?.addSubview((viewController?.view)!)
                viewController?.didMove(toParentViewController: nil)
            } else if tabsViews.count > 0 {
                let view = tabsViews[index]
                scrollView?.addSubview(view)
            }
        }
        
        scrollView?.contentSize = CGSize(width: contentSizeWidth, height: contentSizeHeight)
        scrollView?.bounces = true
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = true
        
        if let tabDefault = showTabDefault {
            scrollToTab(tab: tabDefault)            
        }
    }
    
    func scrollToTab(tab: Int) {
        scrollToPage = tab - 1
        let vc = tabsViewControllers?[tab - 1]
        let viewFrame: CGRect = (vc?.view.frame)!
        
        let point = CGPoint(x: (viewFrame.minX), y: 0.0)
        scrollView?.setContentOffset(point, animated: false)
        
        let buttonTab: UIButton = self.buttonsView?.subviews[tab] as! UIButton
        buttonTab.setTitleColor(UIColor.white, for: .normal)
        var selectedButtonViewFrame = self.selectorTabButtonView?.frame
        selectedButtonViewFrame?.origin.x = (buttonTab.frame.minX)
        self.selectorTabButtonView?.frame = selectedButtonViewFrame!
        previousOffset = (scrollView?.frame.minX)!
    }
    
    func onButtonTabTouch(sender: AnyObject) {
        let button = sender as! UIButton
        scrollToPage = button.tag - 1
        var viewFrame: CGRect?
        
        if (tabsViewControllers?.count)! > 0 {
            let vc = tabsViewControllers?[button.tag - 1]
            viewFrame = vc?.view.frame
        } else {
            let view = tabsViews[button.tag - 1]
            viewFrame = view.frame
        }
        
        let point = CGPoint(x: (viewFrame?.minX)!, y: 0.0)
        scrollView?.setContentOffset(point, animated: true)
        
        for view in (buttonsView?.subviews)! {
            if view is UIButton {
                let button = view as! UIButton
                button.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            let buttonTab = self.buttonsView?.subviews[button.tag] as! UIButton
            buttonTab.setTitleColor(UIColor.white, for: .normal)
            var selectedButtonViewFrame = self.selectorTabButtonView?.frame
            selectedButtonViewFrame?.origin.x = buttonTab.frame.minX
            self.selectorTabButtonView?.frame = selectedButtonViewFrame!
        }
    }
}

extension TabsViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for view in (buttonsView?.subviews)! {
            if view is UIButton {
                let button = view as! UIButton
                button.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
        
        previousOffset = scrollView.contentOffset.x
        scrollToPage = Int(scrollView.contentOffset.x / Utils.screenViewFrame().size.width)
        
        let buttonTab = self.buttonsView?.subviews[scrollToPage + 1] as! UIButton
        buttonTab.setTitleColor(UIColor.white, for: .normal)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = (scrollView.contentOffset.x < previousOffset && scrollToPage > 0) ? scrollToPage - 1 : scrollToPage + 1
        UIView.animate(withDuration: 0.2) {
            let buttonTab = self.buttonsView?.subviews[page]
            var selectedButtonViewFrame = self.selectorTabButtonView?.frame
            selectedButtonViewFrame?.origin.x = (scrollView.contentOffset.x * (buttonTab?.frame.width)!) / Utils.screenViewFrame().size.width
            self.selectorTabButtonView?.frame = selectedButtonViewFrame!
        }
    }
}

