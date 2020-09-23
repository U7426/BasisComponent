//
//  String+Extension.swift
//  English
//
//  Created by U7426 on 2020/5/28.
//  Copyright © 2020 冯龙飞. All rights reserved.
//

import Foundation
public extension Optional where Wrapped == String {
    func orEmpty() -> String {
        return self ?? ""
    }
}
