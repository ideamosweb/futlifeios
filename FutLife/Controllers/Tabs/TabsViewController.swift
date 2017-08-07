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
    let kTabsButtonsViewMinY: CGFloat = 0.0
    
    var tabsViewControllers: [ViewController]?
    var tabsViews: [UIView] = []
    var tabsTitles: [String] = []
    var fontSize: CGFloat?
    
    private var scrollView: UIScrollView?
    private var buttonsView: UIView?
    private var selectorTabButtonView: UIView?
    
    var tabsCount: Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
    }
    
    func configElementsOfView() {
        let scrollViewHeight = Utils.screenViewFrame().size.height - kTabsButtonsViewMinY - kTabsButtonsViewHeight
        
        buttonsView?.backgroundColor = UIColor().darkBlue()
        selectorTabButtonView = UIView(frame: CGRect(x: 0.0, y: (buttonsView?.frame.height)! - 2.0, width: (buttonsView?.frame.width)! / CGFloat(tabsCount!), height: 2.0))
        selectorTabButtonView?.backgroundColor = UIColor().greenDefault()
        buttonsView?.addSubview(selectorTabButtonView!)
        
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: (buttonsView?.frame.maxY)!, width: Utils.screenViewFrame().size.width, height: scrollViewHeight))
        
        view.addSubview(scrollView!)
        view.addSubview(buttonsView!)
    }
    
    func reloadTabs() {
        tabsCount = ((tabsViewControllers?.count)! > 0) ? Float((tabsViewControllers?.count)!) : Float(tabsViews.count)
        let buttonWidth = Utils.screenViewFrame().size.width / CGFloat(tabsCount!)
        
        buttonsView = UIView(frame: CGRect(x: 0.0, y: kTabsButtonsViewMinY, width: Utils.screenViewFrame().size.width, height: kTabsButtonsViewHeight))
        
        configElementsOfView()
        
        var previousButton: UIButton?
        var previousVC: ViewController?
        
        var contentSizeWidth = Utils.screenViewFrame().size.width
        let contentSizeHeight = Utils.screenViewFrame().size.height - kTabsButtonsViewMinY - kTabsButtonsViewHeight
        
        let fontSize = (self.fontSize != nil) ? self.fontSize : 20.0
        
        for index in stride(from: 0, to: Int(tabsCount!), by: 2) {
            let buttonTab = UIButton()
            let tabTitle = ((tabsTitles.count) > 0) ? tabsTitles[index] : "Tab \(index + 1)"
            
            if previousButton == nil {
                buttonTab.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: 44.0)
                
                buttonTab.titleLabel?.font = UIFont().bebasFont(size: fontSize!)
                buttonTab.setTitleColor(UIColor(red: 216.0, green: 219, blue: 223, alpha: 1.0), for: .normal)
                buttonTab.setTitle(tabTitle, for: .normal)
                buttonTab.contentHorizontalAlignment = .center
                buttonTab.tag = index + 1
                
                let separator = UIView(frame: CGRect(x: buttonTab.frame.width - 1, y: (buttonTab.frame.height / 2) / 2, width: 1.0, height: 20.0))
                separator.backgroundColor = UIColor(red: 60.0, green: 143, blue: 130, alpha: 1.0)
                
                buttonTab.addSubview(separator)
                
                previousButton = buttonTab
            } else {
                buttonTab.frame = CGRect(x: (previousButton?.frame.maxX)!, y: 0.0, width: buttonWidth, height: 44.0)
                
                buttonTab.titleLabel?.font = UIFont().bebasFont(size: fontSize!)
                buttonTab.setTitleColor(UIColor(red: 216.0, green: 219, blue: 223, alpha: 1.0), for: .normal)
                buttonTab.setTitle(tabTitle, for: .normal)
                buttonTab.contentHorizontalAlignment = .center
                buttonTab.tag = index + 1
                
                if (index + 1) < Int(tabsCount!) {
                    let separator = UIView(frame: CGRect(x: buttonTab.frame.width - 1, y: (buttonTab.frame.height / 2) / 2, width: 1.0, height: 20.0))
                    separator.backgroundColor = UIColor(red: 60.0, green: 143, blue: 130, alpha: 1.0)
                    
                    buttonTab.addSubview(separator)
                }
                
                previousButton = buttonTab
            }
            
            buttonTab.addTarget(self, action: #selector(onButtonTabTouch), for: .touchUpInside)
            
            buttonsView?.addSubview(buttonTab)
            
            contentSizeWidth = contentSizeWidth * (CGFloat(index) + 1)
            
            if (tabsViewControllers?.count)! > 0 {
                let viewController = tabsViewControllers?[index]
                var tabsFrame = viewController?.view.frame
                
                if previousVC == nil {
                    tabsFrame?.size.width = Utils.screenViewFrame().size.width
                    tabsFrame?.size.height = Utils.screenViewFrame().size.height - CGFloat(kTabsButtonsViewHeight) - CGFloat(Constants.kNavigationBarDefaultHeight)
                    viewController?.view.frame = tabsFrame!
                    
                    previousVC = viewController
                } else {
                    var vcFrame = viewController?.view.frame
                    vcFrame?.origin.x = (previousVC?.view.frame.width)!
                    vcFrame?.size.width = Utils.screenViewFrame().size.width
                    vcFrame?.size.height = Utils.screenViewFrame().size.height - CGFloat(kTabsButtonsViewHeight) - CGFloat(Constants.kNavigationBarDefaultHeight)
                    viewController?.view.frame = vcFrame!
                }
                
                addChildViewController(viewController!)
                scrollView?.addSubview((viewController?.view)!)
                viewController?.didMove(toParentViewController: nil)
            } else if tabsViews.count > 0 {
                let view = tabsViews[index]
                scrollView?.addSubview(view)
            }
        }
        
        scrollView?.contentSize = CGSize(width: contentSizeWidth, height: contentSizeHeight)
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = true
    }
    
    func onButtonTabTouch(sender: AnyObject) {
        let button = sender as! UIButton
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
        
        UIView.animate(withDuration: 0.3) { 
            let buttonTab = self.buttonsView?.subviews[button.tag]
            var selectedButtonViewFrame = self.selectorTabButtonView?.frame
            selectedButtonViewFrame?.origin.x = (buttonTab?.frame.minX)!
            self.selectorTabButtonView?.frame = selectedButtonViewFrame!
        }
    }
    

}
