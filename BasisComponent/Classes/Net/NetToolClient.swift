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
public typealias JsonType = [String : Any]
public enum NetApiError: Error {
    case formatError //格式错误
    case operationError (code:Int,message:String) //业务解析失败
    case unknownError //未知类型错误
    
    public func code() -> Int? {
        switch self {
        case .operationError(code: let code, message: _):
            return code
            
        default:
            return nil
        }
    }
    public func message() -> String? {
        switch self {
        case .formatError:
            return "数据格式错误"
        case .operationError(code: _, message: let message):
            return message
        case .unknownError:
            return "未知错误"
        }
    }
}
public class NetToolClient : ReactiveCompatible {
    public var method = HTTPMethod.post
    
    public var baseUrl =  NetToolClient.configuration.baseUrl
    
    public var path : String!
    
    public var parameters : [String:Any]?
    
    ///是否自动展示错误
    public var autoShowError : Bool = true
    
    /// 请求配置信息
    static var configuration : NetConfigurationType.Type!
    
    /// header
    fileprivate var headers: HTTPHeaders? = HTTPHeaders(NetToolClient.configuration.header)
    
    public init() {}
    
    //APP入口调用一次，设置全局网络请求配置
    public static func configuration(_ configuration : NetConfigurationType.Type){
        self.configuration = configuration
    }
}
///Normal Methord
public extension NetToolClient {
    func startRequest<T>(_ DataType: T.Type, result: ((Result<T>)->())?) -> () where T : NetDataType{
        AF.request(self.baseUrl + self.path, method: self.method, parameters: self.parameters, encoding:URLEncoding.default , headers: self.headers).validate().responseString(completionHandler: { (respondse) in
            switch respondse.result {
            case .success(let value):
                guard let netData = DataType.deserialize(from: value) else {
                    result?(.failure(NetApiError.formatError))
                    return
                }
                if !netData.isSuccess() {
                    if self.autoShowError {
                        _ = HUD.showHudTip(tipString: netData.netMessage())
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
    
    /// 图片上传
    /// - Parameters:
    ///   - images: 图片数组
    ///   - name: 图片名
    ///   - result: 回调
    ///   - progress: 进度
    /// - Returns: void
    func uploadImages(images:[UIImage?],name:String,result:((Result<JsonType>)->())?,progress:((Double)->())?){
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            for (_,image) in images.enumerated() {
                if let image = image {
                    multipartFormData.append(image.compressedData()!, withName: name, fileName: name + ".jpeg", mimeType: "image/jpeg")
                }
            }
            if let params = self.parameters {
                for (key, value) in params {
                    multipartFormData.append(String("\(value)").data(using: String.Encoding.utf8) ?? Data(), withName: key)
                }
            }
        }, to: self.baseUrl + self.path, headers: self.headers)
        request.uploadProgress { (uploadProgress) in
            progress?(uploadProgress.fractionCompleted)
        }
        request.responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JsonType, let json = json  {
                    result?(.success(json))
                }
                else {
                    result?(.failure(NetApiError.formatError))
                }
            case .failure(_):
                result?(.failure(NetApiError.unknownError))
            }
        }
    }
}
///Rx Method
public extension Reactive where Base : NetToolClient{
    func startRequest<T>(_ DataType : T.Type) -> Observable<T> where T : NetDataType{
        return Observable.create({ observer in
            AF.request(self.base.baseUrl + self.base.path, method: self.base.method, parameters: self.base.parameters, encoding:URLEncoding.default , headers: self.base.headers).validate().responseString(completionHandler: { (respondse) in
                switch respondse.result {
                case .success(let value):
                    guard let netData = DataType.deserialize(from: value) else {
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
    func startRequest<T>(_ DataType : T.Type) -> Observable<T> where T : HandyJSON{
        return Observable.create({ observer in
            AF.request(self.base.baseUrl + self.base.path, method: self.base.method, parameters: self.base.parameters, encoding:URLEncoding.default , headers: self.base.headers).validate().responseString(completionHandler: { (respondse) in
                switch respondse.result {
                case .success(let value):
                    guard let netData = DataType.deserialize(from: value) else {
                        observer.onError(NetApiError.formatError)
                        return
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
