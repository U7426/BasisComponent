//
//  NetWorkViewController.swift
//  BasisComponent_Example
//
//  Created by 冯龙飞 on 2020/8/4.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BasisComponent
import HandyJSON
import RxSwift
class User: HandyJSON {
    var name : String?
    required init() {}
}

class NetWorkViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //example 1 : 普通的网络请求
        let api = NetToolClient()
        api.path = "url"
        api.parameters = ["a":1]
        api.request(AnyNetData<User>.self) { (result) in
            if result.isSuccess {
                print(result.value?.data?.name ?? "")
            }
            else{
                print(result.error!)
            }
        }
        //example 2 : RX网络请求
        let rxApi = NetToolClient()
        rxApi.path = "url"
        rxApi.parameters = ["a":1]
        rxApi.rx.request(AnyNetData<User>.self).subscribe(onNext: { value in
            print(value.data?.name ?? "")
            }).disposed(by: disposeBag)
        
    }
}
