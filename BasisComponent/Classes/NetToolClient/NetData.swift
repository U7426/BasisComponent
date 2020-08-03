//
//  NetData.swift
//  English
//
//  Created by U7426 on 2020/5/26.
//  Copyright © 2020 冯龙飞. All rights reserved.
//

import Foundation
import HandyJSON
public protocol NetDataType {
    
    associatedtype T
    
    var code : Int? { get set }
    
    var message : String? { get set }
    
    var data : T? { get set }
    
    var items : T? { get set }
    
    func isSuccess() -> Bool
    
}

public class AnyNetData<R>: NetDataType,HandyJSON {
        
    public typealias T = R
    
    public var code: Int?
    
    public var message: String?
    
    public var data: R?
        
    public var items : R?
    
    public func isSuccess() -> Bool {
        return code == 200
    }
    
    required public init() {}
}

