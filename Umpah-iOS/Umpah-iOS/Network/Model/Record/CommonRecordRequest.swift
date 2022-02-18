//
//  CommonRecordRequest.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/11/09.
//

import Foundation

struct CommonRecordRequest: Codable {
    let date: String
    let stroke: String?

    init(date: String, stroke: String?) {
        self.date = date
        self.stroke = stroke
    }
}
