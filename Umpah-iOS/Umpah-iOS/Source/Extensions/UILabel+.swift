//
//  UILabel+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/08.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = -0.22) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
            
            if #available(iOS 14.0, *) {
                lineBreakStrategy = .hangulWordPriority
            } else {
                lineBreakMode = .byWordWrapping
            }
        }
    }
}
