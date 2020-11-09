//
//  UIDevice+Extension.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/7.
//

import UIKit

public extension UIScreen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let safeBottomMargin : CGFloat = {
        guard #available(iOS 11.0, *) else {
            return 0
        }
        let keyWindow = UIApplication.shared.keyWindow
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }()
    static let safeTopMargin : CGFloat = {
        guard #available(iOS 11.0, *) else {
            return 0
        }
        let keyWindow = UIApplication.shared.keyWindow
        return keyWindow?.safeAreaInsets.top ?? 0
    }()
}
public extension UINavigationBar {
    static let height = 44 + UIScreen.safeTopMargin
}
public extension UITabBar {
    static let height =  49 + UIScreen.safeBottomMargin
}
