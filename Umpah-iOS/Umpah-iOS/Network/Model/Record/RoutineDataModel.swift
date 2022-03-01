//
//  RoutineDataModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/12.
//

import Foundation

struct RoutineOverviewData{
    let title: String = "사용자가생성한루틴"
    var level: Int = 0
    var totalDistance: Int = 2500
    let totalTime: Int = 4500
    let description: String = "설명이 들어갑니다 오랜만에 수영을 하면 몸이 굳으니까 이걸로 몸을 푸는거라고 합니다 그렇다네요 최대 두 줄까지 들어가나요?? ..."
    
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
        let minute = time / 60 < 10 ? "0\(time / 60)" : "\(time / 60)"
        let second = time % 60 < 10 ? "0\(time % 60)" : "\(time % 60)"
        return minute + ":" + second
    }
    
    func getAutomaticTimeToString() -> String{
        let newTime = distance * getTimeAccoringToStorke()
        let minute = newTime / 60 < 10 ? "0\(newTime / 60)" : "\(newTime / 60)"
        let second = newTime % 60 < 10 ? "0\(newTime % 60)" : "\(newTime % 60)"
        return minute + ":" + second
    }
    
    //데이터 형식에 맞게 바꾸기
    func getTimeAccoringToStorke() -> Int{
        switch stroke {
        case "자유형": return 11
        case "평영": return 22
        case "배영": return 33
        case "접영": return 44
            default: return 99
        }
    }
}
