//
//  SwimmingDataViewModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class SwimmingDataViewModel{
    let semaphore = DispatchSemaphore(value: 0)
    let swimmingStorage = SwimmingDataStorage()
    lazy var swimmingWorkoutList: [SwimWorkoutData] = [] {
        didSet {
            semaphore.signal()
        }
    }
    let swimmingSubject = PublishSubject<[SwimmingWorkoutData]>()

    func initSwimmingData(){
        swimmingStorage.loadWorkoutHKSource { completed, error in
            print("complete = \(completed)")
            if completed {
                self.swimmingStorage.refineSwimmingWorkoutData(completion: { workoutList, error in
                    self.swimmingWorkoutList = workoutList
                    self.getStrokeAndDistanceData()
                    self.getHeartRateData()
                })
            }
        }
    }
    
    func getNewSwimmingData(){
        print("----------------getNewSwimmingData---------------------")
        print("lastest swiming date = \(UserDefaults.standard.string(forKey: "lastestWorkoutDate"))")
        swimmingStorage.loadWorkoutHKSource { completed, error in
            print("complete = \(completed)")
            if completed {
                self.swimmingStorage.refineSwimmingWorkoutData(completion: { workoutList, error in
                    self.swimmingWorkoutList = workoutList
                    self.getStrokeAndDistanceData()
                    self.getHeartRateData()
                })
            }
        }
    }
    
    func refineSwimmingDataForServer(){
        var swimmingDataList : [SwimmingWorkoutData] = []
        if swimmingWorkoutList.count <= 0{
            semaphore.wait()
            print("semaphore wait")
        }
                
        swimmingWorkoutList.forEach{ swimming in
            swimming.isCompleted().bind(onNext: { isComplete in
                let labsData = swimming.metadata["HKLapLength"] as? String
                let perLab = Int(labsData?.components(separatedBy: " m")[0] ?? "25")
                var recordList: [RecordLab] = []
                swimming.strokeList.forEach{ stroke in
                    let record = RecordLab(date: stroke.startDate.toKoreaTime(),
                                                    time: stroke.endDate.timeIntervalSince(stroke.startDate), strokeType: stroke.strokeStyle)
                    recordList.append(record)
                }
                
                let swimmingData = SwimmingWorkoutData(startWorkoutDate: swimming.startDate.toKoreaTime(),
                                                       totalBeatPerMinute: swimming.averageHeartRate,
                                                       totalEnergyBurned: swimming.totalEnergyBured,
                                                       distancePerLabs: 25,
                                                       totalSwimmingStrokeCount: Int(swimming.totalSwimmingStrokeCount),
                                                       recordLabsList: recordList)
                swimmingDataList.append(swimmingData)
            }).disposed(by: DisposeBag())

        }
        swimmingSubject.onNext(swimmingDataList)
    }
    
    private func getStrokeAndDistanceData(){
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.refineSwimmingStrokeData(start: swimmingWorkoutList[index].startDate,
                                                     end: swimmingWorkoutList[index].endDate) { strokes, error in
                self.swimmingWorkoutList[index].strokeList = strokes
            }
        }
    }
    
    private func getHeartRateData(){
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.readHeartRate(start: swimmingWorkoutList[index].startDate,
                                          end: swimmingWorkoutList[index].endDate) { heartRate, error in
                self.swimmingWorkoutList[index].averageHeartRate = heartRate
            }
        }
    }
    
}
