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
        
let api = NetToolClient()
api.path = "url"
api.parameters = ["a":1]

//example1 : 普通的网络请求(返回Json)
api.request { (result:Result<JsonType>) in
    if result.isSuccess {
        print(result.value?["name"] ?? "")
    }
    else{
        print(result.error!)
    }
}
//example2 : 普通的网络请求(返回Model)
api.request { (result:Result<User>) in
    if result.isSuccess {
        print(result.value?.name ?? "")
    }
    else{
        print(result.error!)
    }
}
//example3: RX网络请求(返回 Observeable<User>)
let observable = api.rx.request() as Observable<User>
observable.subscribe(onNext: { user in
    print("\(user.name ?? "")")
}).disposed(by: disposeBag)
        
        
    }
}
