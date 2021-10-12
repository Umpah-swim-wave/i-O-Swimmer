//
//  RoutineDataModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/12.
//

import Foundation

struct RoutineOverviewData{
    
    func getDistanceToString() -> String{
        return String(format: "%.1f", Float(totalDistance) / 1000.0) + "km"
    }
    
    func getTimeToString() -> String{
        let minute = (totalTime % 3600) / 60
        let minuteText = minute < 10 ? "0\(minute)" : "\(minute)"
        return "\(totalTime/3600)h " + minuteText + "m"
    }
}

struct RoutineItemData {
    var stroke: String = "영법입력"
    var distance: Int = 999
    var time : Int = 0
    
    func getTimeToString() -> String{
        let minute = time / 60 < 10 ? "0\(time / 60)" : "\(time / 60))"
        let second = time % 60 < 10 ? "0\(time % 60)" : "\(time % 60)"
        return minute + ":" + second
    }
}
