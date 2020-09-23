//
//  UIAlertController+Extension.swift
//  KDLive
//
//  Created by 冯龙飞 on 2019/12/2.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

import Foundation
import RxSwift
public extension UIAlertController {
    enum ActionType {
        case sure;
        case cancel
    }
    struct Action<T> {
        public var title: String?
        public var style: UIAlertAction.Style
        public var value: T
        
        public static func action(title: String?, style: UIAlertAction.Style = .default, value: T) -> Action {
            return Action(title: title, style: style, value: value)
        }
    }
    static func present<T>(in viewController: UIViewController?,
                           title: String? = nil,
                           message: String? = nil,
                           style: UIAlertController.Style,
                           actions: [UIAlertController.Action<T>],
                           handler:((T) -> ())?)
    {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    handler?(action.value)
                }
                alertController.addAction(action)
            }
            
            viewController?.present(alertController, animated: true, completion: nil)
    }
}
public extension Reactive where Base:UIAlertController{
    static func present<T>(in viewController: UIViewController?,
                        title: String? = nil,
                        message: String? = nil,
                        style: UIAlertController.Style,
                        actions: [UIAlertController.Action<T>]) -> Observable<T> {
      guard let _ =  viewController else{
          return Observable.empty()
      }
      return Observable.create { observer in
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        actions.enumerated().forEach { index, action in
          let action = UIAlertAction(title: action.title, style: action.style) { _ in
            observer.onNext(action.value)
            observer.onCompleted()
          }
          alertController.addAction(action)
        }

        viewController?.present(alertController, animated: true, completion: nil)
        return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
      }
    }
}
