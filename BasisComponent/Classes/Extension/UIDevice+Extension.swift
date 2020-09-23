//
//  UIDevice+Extension.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/7.
//

import Foundation
public extension UIDevice {
    static let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)?.replacingOccurrences(of: ".", with: "") ?? ""
    static let iosVersion = UIDevice.current.systemVersion //iOS版本
    static let iosUDID = UIDevice.current.identifierForVendor?.description ?? "" //设备udid
}
