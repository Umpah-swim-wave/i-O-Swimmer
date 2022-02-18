//
//  SignupRequest.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/19.
//

import Foundation

struct SignupRequest: Codable {
    let nickname: String
    let phone: String

    init(nickname: String, phone: String) {
        self.nickname = nickname
        self.phone = phone
    }
}
