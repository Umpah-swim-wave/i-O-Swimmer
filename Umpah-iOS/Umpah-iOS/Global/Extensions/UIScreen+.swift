//
//  UIScreen+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

extension UIScreen{
    public var hasNotch: Bool{
        let deviceRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceRatio > 0.5{
            return false
        } else {
            return true
        }
    }
    class public func getDeviceHeight() -> CGFloat{
        return UIScreen.main.bounds.height
    }
    
    class public func getDeviceWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
}
