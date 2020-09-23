//
//  Target.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/11.
//

import Foundation
class Target: NSObject {
    static let `default` = Target()
    let functions : [String : Mediator.MediatorJsonAndResult] = [
        "test":{json,result in
            Target.default.test(params: json, result: result)
        }
    ]
    func test(params:Mediator.MediatorJson,result:Mediator.MediatorResult) -> () {
        print("targt 执行")
        result?("complete")
    }
}
