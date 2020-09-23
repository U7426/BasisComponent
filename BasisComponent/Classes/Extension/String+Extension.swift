//
//  String+Extension.swift
//  Alamofire
//
//  Created by 冯龙飞 on 2020/8/5.
//

import Foundation
import CommonCrypto
public extension String{
    func getSize( font:UIFont?, size:CGSize?) -> CGSize {
        guard self.count > 0,let _ = font,let _ = size else {
            return CGSize.zero
        }
        var resultSize = NSString(string:self).boundingRect(with:CGSize(width: floor(size!.width), height:floor(size!.height)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font!], context: nil).size
        resultSize = CGSize.init(width: resultSize.width + 1, height: resultSize.height + 1)
        return resultSize
    }
    func md5() -> String {
            let str = self.cString(using: String.Encoding.utf8)
            let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
            CC_MD5(str!, strLen, result)
            let hash = NSMutableString()
            for i in 0 ..< digestLen {
                hash.appendFormat("%02x", result[i])
            }
            free(result)
            return String(format: hash as String)
    }
}
