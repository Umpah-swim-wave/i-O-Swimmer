//
//  Extension+UIView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/25.
//

import UIKit

extension UIView {
    func makeRoundedCellWithShadow(background: UIView) {
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 10
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
    }
}

