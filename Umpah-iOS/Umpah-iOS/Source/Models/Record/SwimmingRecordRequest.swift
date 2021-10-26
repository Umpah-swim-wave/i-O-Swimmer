//
//  SwimmingRecordRequest.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/26.
//

import Foundation

// MARK: - Welcome
struct SwimRecordRequest: Codable {
    let userID: Int
    let workoutList: [WorkoutList]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case workoutList
    }
}

// MARK: - WorkoutList
struct WorkoutList: Codable {
    let startWorkoutDate: String
    let totalBeatPerMinute, totalEnergyBurned: Double
    let distancePerLabs, totalSwimmingStrokeCount: Int
    let recordLabsList: [RecordLabsList]
}

// MARK: - RecordLabsList
struct RecordLabsList: Codable {
    let date: String
    let time: Double
    let strokeType: Int
}
