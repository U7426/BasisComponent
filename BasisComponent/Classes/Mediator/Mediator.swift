//
//  Mediator.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/11.
//

import Foundation
public class Mediator {
    public typealias MediatorJson = [String: Any]
    public typealias MediatorResult = ((Any?)->())?
    public typealias MediatorJsonAndResult = (MediatorJson,MediatorResult) ->()
    public static let `default` = Mediator()
    
    /// 路由调用组件库
    /// - Parameters:
    ///   - module: 模块名
    ///   - functionKey: 方法键
    ///   - params: 要传递的参数
    ///   - result: 回调
    /// - Returns: void
    public func perform(_ module: String, functionKey: String, params: [String:Any],result:MediatorResult = nil) -> () {
        let `class`: AnyClass? = NSClassFromString(module + "." + "Target")
        guard let anyclass = `class` as? NSObject.Type else {
             return
         }
        let object = anyclass.init()
        let mirror = Mirror.init(reflecting: object)
        print("Target:\(module).\(mirror.subjectType)")
        for (name, value) in (mirror.children) {
            if name != "functions" {
                break
            }
            if let function = value as? Dictionary<String,MediatorJsonAndResult> {
                function[functionKey]?(params,result)
                return
            }
        }
    }
}

