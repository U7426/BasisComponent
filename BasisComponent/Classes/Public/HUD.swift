//
//  HUD.swift
//  Cherry
//
//  Created by 冯龙飞 on 2020/5/6.
//  Copyright © 2020 冯龙飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MBProgressHUD
public class HUD : ReactiveCompatible{
    static let HUDQueryViewTag = 101;
    
    /// 展示 tip 文本
    /// - Parameters:
    ///   - tipString: 文本
    ///   - showInView: 展示在的view
    /// - Returns: 展示的hud
    public class func showHudTip(tipString : String?, showInView: UIView? = UIApplication.shared.keyWindow) -> MBProgressHUD {
        guard let tip = tipString, let showInView = showInView else {
            return MBProgressHUD()
        }
        let hud = MBProgressHUD.showAdded(to: showInView , animated: true)
        hud.mode = .text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.text = tip
        hud.margin  = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.0)
        return hud
    }
    
    /// 展示loading
    /// - Parameters:
    ///   - tipString: 文本
    ///   - showInView: 展示在的view
    /// - Returns: 展示的hud
    public class func showHudQuery(tipString:String?, showInView: UIView? = UIApplication.shared.keyWindow) -> MBProgressHUD {
        guard let showInView = showInView else {
            return MBProgressHUD()
        }
        let hud = MBProgressHUD.showAdded(to: showInView, animated: true)
        hud.tag = HUDQueryViewTag
        hud.label.text = tipString
        hud.label.font = UIFont.systemFont(ofSize: 15)
        hud.margin = 10.0
        return hud
        
    }
    
    /// 隐藏loading
    /// - Parameter showInView: 要隐藏的view
    /// - Returns: 是否有loading 并且隐藏
    public class func hiddenHudQuery(showInView: UIView? = UIApplication.shared.keyWindow) -> Bool {
        guard let showInView = showInView else {
            return false
        }
        return MBProgressHUD.hide(for: showInView, animated: true)
    }
}

public extension Reactive where Base == HUD {
    
    /// 是否展示loading的监听者
    static var isAnimating: AnyObserver<(Bool,String?)> {
        return AnyObserver { (isAnimating: Event<(Bool,String?)>) in
            switch isAnimating {
            case .next(let element):
                _ = MainScheduler().schedule(element) { element in
                    if element.0 {
                        _ = HUD.showHudQuery(tipString:element.1)
                    }
                    else{
                       _ = HUD.hiddenHudQuery()
                    }
                    return Disposables.create()
                }
            case .completed:
                _ = HUD.hiddenHudQuery()
            case .error:
                _ = HUD.hiddenHudQuery()
           
            }
        }
    }
    
}
