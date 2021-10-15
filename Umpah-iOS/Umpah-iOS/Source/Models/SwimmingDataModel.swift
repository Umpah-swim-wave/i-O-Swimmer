//
//  SwimmingData.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/15.
//

import Foundation
import HealthKit

//TODO: MetaData에서 "HKLapLength": 25 m 값 추출하기
struct SwimWorkoutData {
    var startDate: Date
    var endDate: Date
    var duration : Double
    var totalDistance : Double
    var totalEnergyBured : Double
    var workourActivityType: HKWorkoutActivityType
    var totalSwimmingStrokeCount: Double
    var metadata: [String : Any]
    var distanceList: [SwimmingDistanceData] = []
    var strokeList: [SwimmingStrokeData] = []
    
    func display(){
        print("---------------------------")
        print("startDate =  \(startDate)")
        print("endDate =  \(endDate)")
        print("duration =  \(duration)")
        print("totalDistance =  \(totalDistance)")
        print("totalEnergyBured =  \(totalEnergyBured)")
        print("workourActivityType =  \(workourActivityType)")
        print("totalSwimmingStrokeCount =  \(totalSwimmingStrokeCount)")
        print("metadata =  \(metadata)")
        print("---------------------------")
    }
}

struct SwimmingDistanceData {
    var startDate: Date
    var endDate: Date
    var timeInterval: Double
    
    init(start: Date, end: Date){
        startDate = start
        endDate = end
        timeInterval = start.timeIntervalSince(end)
    }
    
    func changeStringArray() -> [String]{
        return [startDate.toKoreaTime(), endDate.toKoreaTime(), timeInterval.description]
    }
}


struct SwimmingStrokeData{
    var startDate: Date
    var endDate: Date
    var count: Int = 0
    var strokeStyle: Int = 0
    var storkeStyleENG: String = ""
    var strokeStyleKR: String = ""

    func changeStringArray() -> [String] {
        return [strokeStyle.description, strokeStyleKR, storkeStyleENG]
    }
    
    func display(){
        print("--------------------------------------")
        print("strokes count : = \(count)")
        print("strokes style : = \(strokeStyle)")
        print("--------------------------------------")
    }
}
