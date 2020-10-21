//
//  NetToolClient.swift
//  KDBasisComponents_Example
//
//  Created by 冯龙飞 on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import BasisComponent
import RxSwift
extension NetToolClient {
    func request<T>(_ result: ((Result<T>)->())?) {
        self.startRequest(AnyNetData<T>.self) {
            if $0.isSuccess {
                result?(.success($0.value!.data!))
            }
            else{
                result?(.failure($0.error!))
            }
        }
    }
    func request<T:NetDataType>(_ result: ((Result<T>)->())?) {
        self.startRequest(T.self) {
            if $0.isSuccess {
                result?(.success($0.value!))
            }
            else{
                result?(.failure($0.error!))
            }
        }
    }
}

extension Reactive where Base: NetToolClient {
    func request<T>() -> Observable<T> {
        return self.startRequest(AnyNetData<T>.self).map {
            $0.data!
        }
    }
}
