//
//  NSObject+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/12.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
