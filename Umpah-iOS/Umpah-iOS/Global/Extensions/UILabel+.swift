//
//  UILabel+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/08.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = -0.22, lineSpacing: CGFloat = 0.0) {
        if let labelText = self.text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedText = NSAttributedString(string: labelText,
                                                attributes: [.kern: kernValue,
                                                             .paragraphStyle: paragraphStyle])
            if #available(iOS 14.0, *) {
                lineBreakStrategy = .hangulWordPriority
            } else {
                lineBreakMode = .byWordWrapping
            }
        }
    }
    
    func changeCharacterAttribute(words: [String], size: CGFloat, kernValue: Double = 2) {
        if let labelText = text, labelText.count > 0 {
            let attributedStr = NSMutableAttributedString(string: labelText)
            attributedStr.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedStr.length - 1))
            
            for word in words {
                attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: (labelText as NSString).range(of: word))
            }
            
            attributedText = attributedStr
        }
    }
}
