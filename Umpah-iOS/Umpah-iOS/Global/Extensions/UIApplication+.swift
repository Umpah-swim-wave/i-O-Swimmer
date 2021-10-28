//
//  UIApplication+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

extension UIApplication {
    /// iOS 13.0 이하 버전만 가능합니다.
    static var statusBarHeight: CGFloat {
        return shared.statusBarFrame.height
    }
}
