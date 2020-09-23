//
//  UIImage+Extension.swift
//  KDBasisComponents
//
//  Created by 冯龙飞 on 2020/8/24.
//

import Foundation
public extension UIImage {
    
    /// 生成渐变image
    /// - Parameters:
    ///   - size: 大小
    ///   - colors: 渐变颜色
    ///   - startPoint: 开始位置
    ///   - endPoint: 结束位置
    ///   - locations: 渐变
    /// - Returns: UIImage
    static func gradientImage(size: CGSize, colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5), locations: [NSNumber]? = nil) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.colors = colors.map({
            return $0.cgColor
        })
        
        UIGraphicsBeginImageContext(size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
