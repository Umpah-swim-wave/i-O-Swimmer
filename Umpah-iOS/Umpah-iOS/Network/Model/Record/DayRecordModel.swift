//
//  DayRecordModel.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/19.
//

import Foundation

// MARK: - DayRecordModel
struct DayRecordModel: Codable {
    let success: Bool
    let message: String
    let data: DayRecord
}

// MARK: - DataClass
struct DayRecord: Codable {
    let date: String
    let totalDistance, totalTime, totalCalorie, totalBPM: Int
    let freestyleTotalDistance: Int
    let freestyleTotalSpeed: String
    let breastTotalDistance: Int
    let breastTotalSpeed: String
    let backTotalDistance: Int
    let backTotalSpeed: String
    let butterflyTotalDistance: Int
    let butterflyTotalSpeed, imTotalSpeed: String
    let recordLabsList: [RecordLabsList]

    enum CodingKeys: String, CodingKey {
        case date, totalDistance, totalTime, totalCalorie
        case totalBPM = "totalBpm"
        case freestyleTotalDistance, freestyleTotalSpeed, breastTotalDistance, breastTotalSpeed, backTotalDistance, backTotalSpeed, butterflyTotalDistance, butterflyTotalSpeed, imTotalSpeed, recordLabsList
    }
}

// MARK: - RecordLabsList
struct RecordLabsList: Codable {
    let recordID: Int
    var stroke: String
    var distance, time: Int
    var speed: String

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case stroke, distance, time, speed
    }
}
