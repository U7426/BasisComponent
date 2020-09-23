//
//  HUD.swift
//  Cherry
//
//  Created by 冯龙飞 on 2020/5/6.
//  Copyright © 2020 冯龙飞. All rights reserved.
//

import Foundation
import MBProgressHUD
public class HUD {
    static let HUDQueryViewTag = 101;
    public class func showHudTip(tipString : String?, showInView: UIView? = UIApplication.shared.keyWindow) -> () {
        guard let tip = tipString, let showInView = showInView else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: showInView , animated: true)
        hud.mode = .text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.text = tip
        hud.margin  = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.0)
    }
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
}
