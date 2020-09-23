//
//  NetData.swift
//  English
//
//  Created by U7426 on 2020/5/26.
//  Copyright © 2020 冯龙飞. All rights reserved.
//

import Foundation
import HandyJSON
public protocol NetDataType:HandyJSON {
    
    ///服务端返回的json中的data 要转换的model
    associatedtype Element
    
    ///业务是否成功
    func isSuccess() -> Bool
    
    /// 业务data
    func netData() -> Element?
    
    /// code码
    func netCode() -> Int?
    
    /// 服务端提示信息
    func netMessage() -> String?
    
}


