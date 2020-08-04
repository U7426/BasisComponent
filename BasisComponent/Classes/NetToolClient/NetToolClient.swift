//
//  NetToolClient.swift
//  English
//
//  Created by U7426 on 2020/5/26.
//  Copyright © 2020 冯龙飞. All rights reserved.
//
import Foundation
import Alamofire
import HandyJSON
import RxCocoa
import RxSwift
typealias JsonType = [NSString : Any]
public enum NetApiError:Error {
    case formatError //格式错误
    case operationError (code:Int,message:String) //业务解析失败
    case unknownError //未知类型错误
}
public class NetToolClient : ReactiveCompatible {
    public var method = HTTPMethod.post
    
    public var baseUrl =  "https://api.github.com/search/repositories?q="
    
    public var path : String!
    
    public var parameters : [String:Any]?
    
    ///是否自动展示错误
    public var autoShowError : Bool = true
    
    /// header
    fileprivate var headers: HTTPHeaders? = [:]
    
    public init() {
        
    }
}
///Normal Methord
extension NetToolClient {
    public func request<T>(_ DataType: T.Type, result: ((Result<T>)->())?) -> () where T : NetDataType{
        AF.request(self.baseUrl + self.path, method: self.method, parameters: self.parameters, encoding:URLEncoding.default , headers: self.headers).validate().responseJSON(completionHandler: { (respondse) in
            switch respondse.result {
            case .success(let value):
                guard let json:[String:Any] = value as? [String:Any] else {
                    result?(.failure(NetApiError.formatError))
                    return
                }
                guard let netData = DataType.deserialize(from: json) else {
                    result?(.failure(NetApiError.formatError))
                    return
                }
                if !netData.isSuccess() {
                    if self.autoShowError {
                        print("展示错误")
                    }
                    result?(.failure(NetApiError.operationError(code: netData.netCode() ?? -200, message: netData.netMessage() ?? "无错误信息")))
                    return
                }
                result?(.success(netData))
            case .failure(let error):
                result?(.failure(error))
            }
        })
    }
}
///Rx Method
extension Reactive where Base : NetToolClient{
    public func request<T>(_ DataType : T.Type) -> Observable<T> where T : NetDataType{
        return Observable.create({ observer in
            AF.request(self.base.baseUrl + self.base.path, method: self.base.method, parameters: self.base.parameters, encoding:URLEncoding.default , headers: self.base.headers).validate().responseJSON(completionHandler: { (respondse) in
                switch respondse.result {
                case .success(let value):
                    guard let json:[String:Any] = value as? [String:Any] else {
                        observer.onError(NetApiError.formatError)
                        return
                    }
                    guard let netData = DataType.deserialize(from: json) else {
                        observer.onError(NetApiError.formatError)
                        return
                    }
                    if !netData.isSuccess() {
                        observer.onError(NetApiError.operationError(code: netData.netCode() ?? -200, message: netData.netMessage() ?? "无错误信息"))
                    }
                    observer.onNext(netData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        })
    }
}
