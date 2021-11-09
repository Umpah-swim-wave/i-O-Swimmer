//
//  WeekRecordRequest.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/11/09.
//

import Foundation

struct WeekRecordRequest: Codable {
    let startDate: String
    let endDate: String
    let stroke: String

    init(_ startDate: String, _ endDate: String, _ stroke: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.stroke = stroke
    }
}
