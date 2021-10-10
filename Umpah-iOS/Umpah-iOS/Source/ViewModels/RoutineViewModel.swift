//
//  RoutineViewModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import Foundation
import RxSwift

class RoutineViewModel {
    
    var routineStorage = RoutineStorage()
    
    func getRoutineItemCount(index: Int) -> Int{
        let setTitle = routineStorage.routineSetTitleList[index]
        return routineStorage.routineList[setTitle]?.count ?? 0
    }
    
    func getTotalRoutinesDistanceToString() -> String{
        let sum = getTotalDistanceInAllRoutines()
        return String(format: "%.1f", Float(sum) / 1000.0) + "km"
    }
    
    func getTotalRoutinesTimeToString() -> String{
        return getTimeToString(time: getTotalTimeInAllRoutines())
    }
    
    func getTotalDistanceInAllRoutines() -> Int{
        var sum = 0
        routineStorage.routineSetTitleList.forEach{
            sum += self.getTotalDistanceInSetRoutines(setTitle: $0)
        }
        return sum
    }
    
    private func getTotalDistanceInSetRoutines(setTitle: String) -> Int{
        var sum = 0
        routineStorage.routineList[setTitle]?.forEach {
            sum += $0.distance
        }
        return sum
    }

        
    func getTotalTimeInAllRoutines() -> Int{
        var sum = 0
        routineStorage.routineSetTitleList.forEach{
            sum += self.getTotalTimeInSetRoutines(setTitle: $0)
        }
        return sum
    }
    
    private func getTotalTimeInSetRoutines(setTitle: String) -> Int{
        var sum = 0
        routineStorage.routineList[setTitle]?.forEach {
            sum += $0.time
        }
        return sum
    }
    
    func getTotalTimeToString() -> String{
        return getTimeToString(time: getTotalTimeInAllRoutines())
    }
    
    func getTimeToString(time: Int) -> String{
        let hour = time / 3600 < 10 ? "0\(time / 3600)" : "\(time / 3600)"
        let minute = (time % 3600)/60 < 10 ? "0\((time % 3600)/60)" : "\((time % 3600)/60)"
        return hour + "h " + minute + "m"
    }
}
