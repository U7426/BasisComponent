# BasisComponent

[![CI Status](https://img.shields.io/travis/U7426/BasisComponent.svg?style=flat)](https://travis-ci.org/U7426/BasisComponent)
[![Version](https://img.shields.io/cocoapods/v/BasisComponent.svg?style=flat)](https://cocoapods.org/pods/BasisComponent)
[![License](https://img.shields.io/cocoapods/l/BasisComponent.svg?style=flat)](https://cocoapods.org/pods/BasisComponent)
[![Platform](https://img.shields.io/cocoapods/p/BasisComponent.svg?style=flat)](https://cocoapods.org/pods/BasisComponent)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



#### Mediator
``` Swift
路由的基本实现:
/// 路由调用组件库
/// - Parameters:
///   - module: 模块名
///   - functionKey: 方法键
///   - params: 要传递的参数
///   - result: 回调
/// - Returns: void
public func perform(_ module: String, functionKey: String, params: [String:Any],result:MediatorResult = nil) -> () {
    let `class`: AnyClass? = NSClassFromString(module + "." + "Target")
    guard let anyclass = `class` as? NSObject.Type else {
        return
    }
    let object = anyclass.init()
    let mirror = Mirror.init(reflecting: object)
    print("Target:\(module).\(mirror.subjectType)")
    for (name, value) in (mirror.children) {
        if name != "functions" {
            break
        }
        if let function = value as? Dictionary<String,MediatorJsonAndResult> {
            function[functionKey]?(params,result)
            return
        }
    }
}
    
用例Target:
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

路由调用测试:
Mediator.default.perform("BasisComponent", functionKey: "test", params: [:]) { result in
   print(result ?? "Complete")
}
```
## Requirements

## Installation

BasisComponent is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BasisComponent'
```

## Author

U7426, u7426fenglongfei@163.com

## License

BasisComponent is available under the MIT license. See the LICENSE file for more info.
