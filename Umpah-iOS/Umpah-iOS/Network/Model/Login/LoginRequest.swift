//
//  LoginRequest.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/19.
//

import Foundation

struct LoginRequest: Codable {
    let phone: String

    init(phone: String) {
        self.phone = phone
    }
}
