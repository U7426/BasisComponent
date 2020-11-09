//
//  NetConfigurationType.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/5.
//

import Foundation
/// 请求配置，提供header，baseUrl，header 信息
public protocol NetConfigurationType{
    
    /// baseUrl
    static var baseUrl : String { set get }
    
    /// 请求头
    static var header : [String : String] { set get }
    
    /// 更新baseUrl
    /// - Parameter baseUrl: baseUrl
    static func updateBaseUrl(_ baseUrl: String?) -> ()
    
    /// 更新header
    static func updateHeader(_ header: [String : String]) -> ()
}

public extension NetConfigurationType{
    static func updateBaseUrl(_ baseUrl: String?) -> (){
        guard let baseUrl = baseUrl else {
            return
        }
        Self.baseUrl = baseUrl
    }
    
    static func updateHeader(_ header: [String : String]) -> () {
        Self.header = header
    }
}
