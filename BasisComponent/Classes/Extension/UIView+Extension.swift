//
//  UIView+Extension.swift
//  School
//
//  Created by 冯龙飞 on 2018/8/25.
//  Copyright © 2018年 冯龙飞. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift
let kTagLineView = 1007
public extension UIView {
    func doCircleFrame() {
        self.needGetFrame()
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = self.frame.size.height/2;

    }
    func needGetFrame(){
        if self.frame.size.width == 0 || self.frame.size.height == 0{
            self.layoutIfNeeded()
        }
    }
    func doCornerRadius(radius:CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
    }
    func doNotCircleFrame() {
        self.layer.cornerRadius = 0.0;
        self.layer.borderWidth = 0.0;
    }
    func doBorder(width:CGFloat,color:UIColor = .white,cornerRadius:CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = width;
        self.layer.borderColor = color.cgColor;
    }
    func lineView(pointY:CGFloat,color:UIColor = UIColor(hex: 0xf9f9f9)!,leftSpace:CGFloat = 0,rightSpace:CGFloat = 0) -> UIView{
        let line = UIView(frame: CGRect(x: leftSpace, y: pointY, width: self.frame.width - leftSpace - rightSpace, height: 1.0))
        line.backgroundColor = color
        return line
    }
    func addLine(hasUp:Bool,hasDown:Bool,leftSpace:CGFloat = 0.0, rightSpace:CGFloat  = 0.0,color:UIColor = UIColor(hex: 0xf9f9f9)!){
        self.needGetFrame()
        for item in self.subviews {
            if item.tag == kTagLineView{
                item.removeFromSuperview()
            }
        }
        if hasUp {
            let upView = self.lineView(pointY: 0, color: color, leftSpace: leftSpace, rightSpace: rightSpace)
            upView.tag = kTagLineView
            self.addSubview(upView)
        }
        if hasDown {
            let downView = self.lineView(pointY: self.frame.height - 1.0, color: color, leftSpace: leftSpace, rightSpace: rightSpace)
            downView.tag = kTagLineView
            self.addSubview(downView)
        }
    }
}
