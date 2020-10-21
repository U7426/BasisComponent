//
//  ViewController.swift
//  BasisComponent
//
//  Created by U7426 on 07/27/2020.
//  Copyright (c) 2020 U7426. All rights reserved.
//

import UIKit
import BasisComponent
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //路由调用测试
        Mediator.default.perform("BasisComponent", functionKey: "test", params: [:]) { result in
            print(result ?? "Complete")
        }
    }

}

