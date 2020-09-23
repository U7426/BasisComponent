
//
//  Rx+Extension.swift
//  KDLive
//
//  Created by 冯龙飞 on 2019/12/2.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
public extension ObservableConvertibleType{
     func asDriverJustShowErrorMessage()->Driver<Element>{
        return self.asDriver(onErrorRecover: {
            if  let error = $0 as? NetApiError {
                HUD.showHudTip(tipString: error.description)
            }
            return Driver.empty()
        })
    }
}
public extension Reactive {
    var disposeBag : DisposeBag {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "DisposeBag".hashValue)
            objc_setAssociatedObject(self.base, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "DisposeBag".hashValue)
            if let disposeBag = objc_getAssociatedObject(self, key) as? DisposeBag {
                return disposeBag
            }
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self.base, key, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeBag
        }
    }
}
extension NetApiError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .formatError:
            return "数据格式错误，解析失败"
        case .operationError(code: _, message: let message):
            return message
        case .unknownError:
            return "网络异常"
        }
    }
}
