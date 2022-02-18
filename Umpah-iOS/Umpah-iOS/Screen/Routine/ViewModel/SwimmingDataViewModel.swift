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
    let disposeBag = DisposeBag()
    let swimmingStorage = SwimmingDataStorage()
    lazy var swimmingWorkoutList: [SwimWorkoutData] = [] {
        didSet(oldList){
            if swimmingWorkoutList.count != oldList.count {
                semaphore.signal()
                print("semaphore 시그널 불림")
            }
        }
    }
    let swimmingSubject = PublishSubject<[SwimmingWorkoutData]>()

    func initSwimmingData(){
        Logger.debugDescription("soucre 가져오기")
        swimmingStorage.loadWorkoutHKSource { completed, error in
            print("complete = \(completed)")
            if completed {
                self.updateNewSwimmingDate()
                //self.swimmingStorage.startObservingNewWorkouts()
                self.swimmingStorage.refineSwimmingWorkoutData(start: nil, completion: { workoutList, error in
                    self.swimmingWorkoutList = workoutList
                    self.getStrokeAndDistanceData()
                    self.getHeartRateData()
                    self.swimmingStorage.startObservingNewWorkouts()
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
        Logger.debugDescription("")
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.refineSwimmingStrokeData(start: swimmingWorkoutList[index].startDate,
                                                     end: swimmingWorkoutList[index].endDate) { strokes, error in
                self.swimmingWorkoutList[index].strokeList = strokes
            }
        }
    }
    
    private func getHeartRateData(){
        Logger.debugDescription("")
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.readHeartRate(start: swimmingWorkoutList[index].startDate,
                                          end: swimmingWorkoutList[index].endDate) { heartRate, error in
                self.swimmingWorkoutList[index].averageHeartRate = heartRate
            }
        }
    }
    
    func updateNewSwimmingDate(){
        swimmingStorage
            .newWorkOutDateSubject
            .bind(onNext: { [weak self] startDate in
                print("newWorkOutDateSubject = \(startDate)")
                Logger.debugDescription("startDate \(startDate)")
                guard let self = self else { return }
                self.swimmingStorage.refineSwimmingWorkoutData(start: startDate, completion: { workoutList, error in
                    print("refineSwimmingWorkoutData")
                    if self.swimmingWorkoutList != workoutList{
                        print("둘이 다른 날 -> \(startDate)")
                        self.swimmingWorkoutList = workoutList
                        self.getStrokeAndDistanceData()
                        self.getHeartRateData()
                        self.refineSwimmingDataForServer()
                    }
                    print("기존의 데이터랑 같음")
                })
            }).disposed(by: disposeBag)
    }
}
