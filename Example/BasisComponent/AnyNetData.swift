//
//  NetWork.swift
//  BasisComponent_Example
//
//  Created by 冯龙飞 on 2020/8/4.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON
import BasisComponent
class AnyNetData<R>{

    var message : String?

    var code : Int?

    var data : R?
    
    required init() {}
    
}
extension AnyNetData : NetDataType{
    typealias Element = R
    
    func isSuccess() -> Bool {
        return code == 200
    }
    
    func netData() -> R? {
        return data
    }
    
    func netCode() -> Int? {
        return code
    }
    
    func netMessage() -> String? {
        return message
    }
}
