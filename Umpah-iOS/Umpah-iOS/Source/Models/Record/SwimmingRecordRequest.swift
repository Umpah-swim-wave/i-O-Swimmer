//
//  SwimmingRecordRequest.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/26.
//

import Foundation

// MARK: - Welcome
struct SwimmingRecordRequest: Codable {
    let userID: Int
    let workoutList: [SwimmingWorkoutData]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case workoutList
    }
    
    
}

// MARK: - WorkoutList
struct SwimmingWorkoutData: Codable {
    let startWorkoutDate: String
    let totalBeatPerMinute, totalEnergyBurned: Double
    let distancePerLabs, totalSwimmingStrokeCount: Int
    let recordLabsList: [RecordLab]
    
    func display(){
        print("---------------------------")
        print("startDate =  \(startWorkoutDate)")
        print("totalBeatPerMinute =  \(totalBeatPerMinute)")
        print("totalEnergyBurned =  \(totalEnergyBurned)")
        print("distancePerLabs =  \(distancePerLabs)")
        print("totalSwimmingStrokeCount =  \(totalSwimmingStrokeCount)")
        print("recordLabsList =  \(recordLabsList)")
        print("---------------------------")
    }
}

// MARK: - RecordLabsList
struct RecordLab: Codable {
    let date: String
    let time: Double
    let strokeType: Int
}

struct CommonRespose: Codable {
    let status: Int
    let message: String
    let success: Bool
    let data: String?
}
