//
//  NibLoadableView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/19.
//

import UIKit

protocol NibLoadableView {}

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
}
