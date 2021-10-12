//
//  RoutineDataModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/12.
//

import Foundation

struct RoutineOverviewData{
    let title: String
    let level: String
    let totalDistance: Int
    let totalTime: Int
    let description: String
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
