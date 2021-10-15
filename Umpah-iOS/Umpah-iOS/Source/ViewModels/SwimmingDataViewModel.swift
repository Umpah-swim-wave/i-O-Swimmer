//
//  SwimmingDataViewModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/16.
//

import Foundation

class SwimmingDataViewModel{
    let swimmingStorage = SwimmingDataStorage()
    var swimmingWorkoutList: [SwimWorkoutData] = []
    
    func initSwimmingData(){
        swimmingStorage.loadWorkoutHKSource()
        swimmingStorage.refineSwimmingWorkoutData(completion: { workoutList, error in
            self.swimmingWorkoutList = workoutList
            self.getStrokeAndDistanceData()
        })
    }
    
    private func getStrokeAndDistanceData(){
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.refineSwimmingStrokeData(start: swimmingWorkoutList[index].startDate,
                                                     end:  swimmingWorkoutList[index].endDate) { strokes, error in
                self.swimmingWorkoutList[index].strokeList = strokes
            }
            swimmingStorage.refineSwimmingDistanceData(start: swimmingWorkoutList[index].startDate,
                                                       end: swimmingWorkoutList[index].endDate) { distances, error in
                self.swimmingWorkoutList[index].distanceList = distances
            }
        }
    }
    
}
