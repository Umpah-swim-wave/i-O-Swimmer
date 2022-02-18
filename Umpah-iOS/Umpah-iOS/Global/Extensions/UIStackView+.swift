//
//  UIStackView+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/13.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ view: [UIView]) {
        view.forEach { self.addArrangedSubview($0) }
    }
}
