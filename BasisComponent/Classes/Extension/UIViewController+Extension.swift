//
//  UIViewController+Extension.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/7.
//

import Foundation
public extension UIViewController {
    
    /// 顶部导航条和安全区高度
    var topBarHeight : CGFloat  {
        return (self.navigationController?.navigationBar.height ?? 0) + UIScreen.safeTopMargin
    }
    
    /// 底部Tabbar和安全区高度
    var bottomBarHeight : CGFloat {
        return self.tabBarController?.tabBar.height ?? 0
    }
    
    /// push
    /// - Parameter viewController: push的viewcontroller
    class func goToVC(viewController:UIViewController){
        let nav = presentingVC()?.navigationController
        if let _ = nav {
            nav?.pushViewController(viewController, animated: true)
        }
    }
    
    /// Returns the top most view controller from given view controller's stack.
    static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
    
    /// 查找最上层viewcontroller
    /// - Returns: 返回viewcontroler
     class func presentingVC() -> UIViewController? {
        var rootViewController: UIViewController?
        for window in UIApplication.shared.windows where !window.isHidden {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        return UIViewController.topMost(of: rootViewController)
    }
}
