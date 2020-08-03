//
//  NetToolClient.swift
//  English
//
//  Created by U7426 on 2020/5/26.
//  Copyright © 2020 冯龙飞. All rights reserved.
//
import Alamofire
import Foundation
import HandyJSON
import RxCocoa
import RxSwift
typealias JsonType = [NSString : Any]
extension Dictionary : HandyJSON {}
enum NetApiError:Error {
    case formatError //格式错误
    case operationError (code:Int,message:String) //业务解析失败
}
class NetToolClient : ReactiveCompatible {
    var method = HTTPMethod.post
    
    var baseUrl =  "https://api.github.com/search/repositories?q="
    
    var path : String!
    
    var parameters : [String:Any]?
    
    ///是否自动展示错误
    var autoShowError : Bool = true
    
    /// header
    fileprivate var headers: HTTPHeaders? = [:]
}

extension Reactive where Base : NetToolClient{
    
    /// 请求泛型 T 为 Array，element 遵守 handyjson
    /// - Returns: 可观察序列
    func request<T>() -> Observable<T> where T : Sequence , T.Element : HandyJSON{
        return self.startRequest()
    }
    
    /// 请求泛型 T 遵守handyjson 协议
    /// - Returns: 可观察序列
    func request<T:HandyJSON>() -> Observable<T>{
        return self.startRequest()
    }
    
    private func startRequest<T>() -> Observable<T> {
        return Observable.create({ observer in
            AF.request(self.base.baseUrl + self.base.path, method: self.base.method, parameters: self.base.parameters, encoding:URLEncoding.default , headers: self.base.headers).validate().responseJSON(completionHandler: { (respondse) in
                switch respondse.result {
                case .success(let value):
                    guard let json:[String:Any] = value as? [String:Any] else {
                        observer.onError(NetApiError.formatError)
                        return
                    }
                    guard let netData = AnyNetData<T>.deserialize(from: json) else {
                        observer.onError(NetApiError.formatError)
                        return
                    }
                    if let code = netData.code ,code != 200 {
                        observer.onError(NetApiError.operationError(code: code, message: netData.message ?? ""))
                    }
                    if let data = netData.data {
                        observer.onNext(data)                        
                    }
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        })
    }
}
