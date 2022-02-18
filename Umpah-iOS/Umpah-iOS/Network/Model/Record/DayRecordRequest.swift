//
//  DayRecordRequest.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/18.
//

import Foundation

struct DayRecordRequest: Codable {
    let date: String

    init(date: String) {
        self.date = date
    }
}
