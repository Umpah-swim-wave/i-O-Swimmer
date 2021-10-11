//
//  UIApplication+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
