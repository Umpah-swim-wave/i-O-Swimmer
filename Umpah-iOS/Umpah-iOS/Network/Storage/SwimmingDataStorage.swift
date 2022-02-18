//
//  HealthKitDataStore.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/15.
//

import Foundation
import HealthKit
import RxSwift

class SwimmingDataStorage{
    let semaphore = DispatchSemaphore(value: 0)
    let healthStore = HKHealthStore()
    var sourceSet: Set<HKSource> = []{
        didSet{
            semaphore.signal()
            print("signal 불림")
        }
    }
    let newWorkOutDateSubject = PublishSubject<Date>()
    let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
    let datePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .year, value: -1, to: Date()),
                                                    end: Date(),
                                                    options: .strictEndDate)
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    
    //MARK: 가장먼저 source를 가져와야함.
    func loadWorkoutHKSource(completion: @escaping (Bool, Error?) -> Void){
        Logger.debugDescription("")
        let sampleType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sourceQuery = HKSourceQuery.init(sampleType: sampleType,
                                             samplePredicate: datePredicate){ (query, result, error) in
            guard let sources = result else{
                print("source nil")
                completion(false, error)
                return
            }
            self.sourceSet.removeAll()
            for src in sources {
                print("source 가져와졌음, src.name = \(src.name)")
                print("source 가져와졌음, src.bundleIdentifier = \(src.bundleIdentifier)")
                self.sourceSet.insert(src)
            }
            completion(true, error)
        }
        healthStore.execute(sourceQuery)
    }

    //MARK: 수영 전체 workoutData
    //TODO: start, end data 언제 제대로 처리할 지
    func readSwimmingWorkout(start date: Date?, completion: @escaping ([HKSample], Error?) -> Void ){
        //loadWorkoutHKSource()
        Logger.debugDescription("")
        if sourceSet == []{
            semaphore.wait()
            print("sourceSet is empty")
        }
        print("source data 시작")
        print("start date \(date)")
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let predicate = HKQuery.predicateForSamples(withStart: date ?? startDate, end: Date(), options: .strictEndDate)
        let swimmingPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [swimmingPredicate, sourcePredicate])
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                  predicate: compound,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]){(query, result, error) in
            guard let samples = result else {
                print("workout으로 넘어져 오는게 없음")
                completion([], error)
                return
            }
            completion(samples, nil)
        }
        healthStore.execute(query)
    }

    func refineSwimmingWorkoutData(start date: Date?, completion: @escaping ([SwimWorkoutData], Error?) -> Void){
        Logger.debugDescription("")
        readSwimmingWorkout(start: date) { sampleList, error in
            var swimmingWorkoutList: [SwimWorkoutData] = []
            for sample in sampleList {
                let src = sample as! HKWorkout
                let duration = floor(src.duration / 100) * 100
                
                let meterUnit = HKUnit.meter()
                let totalDistance = src.totalDistance?.doubleValue(for: meterUnit) ?? 1
              
                let kiloCalorie = HKUnit.kilocalorie()
                let totalEnergy = src.totalEnergyBurned?.doubleValue(for: kiloCalorie) ?? 0
                
                let strokes = src.totalSwimmingStrokeCount?.doubleValue(for: HKUnit.count()) ?? 0
                let metaData = src.metadata ?? [:]
                
                let swimming = SwimWorkoutData(startDate: sample.startDate,
                                               endDate: sample.endDate,
                                               duration: duration,
                                               totalDistance: totalDistance,
                                               totalEnergyBured: totalEnergy,
                                               averageHeartRate: -1,
                                               totalSwimmingStrokeCount: strokes,
                                               metadata: metaData)
                swimmingWorkoutList.append(swimming)
                swimming.display()
            }
            completion(swimmingWorkoutList, nil)
        }
    }
    
    func readSwimmingDistance(start: Date, end: Date, completion: @escaping ([HKSample], Error?) -> Void){
        Logger.debugDescription("")
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else{ return }
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: datePredicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, reault, error) in
            guard let sampleList = reault else{
                print("sample data 안넘어옴")
                completion([], error)
                return
            }
            completion(sampleList, nil)
        }
        healthStore.execute(query)
    }

    //MARK: 시작시간, 종료시간 , 운동시간
    func refineSwimmingDistanceData(start: Date, end: Date, completion: @escaping ([SwimmingDistanceData], Error?) -> Void){
        Logger.debugDescription("")
        var list: [SwimmingDistanceData] = []
        readSwimmingDistance(start: start, end: end) { sampleList , error in
            for sample in sampleList{
                let distance = SwimmingDistanceData(start: sample.startDate, end: sample.endDate)
                list.append(distance)
            }
            completion(list, nil)
        }
    }
    
    func readHeartRate(start: Date, end: Date, completion: @escaping(Double, Error?) -> Void){
        Logger.debugDescription("")
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: datePredicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) { query, result, error in
            
            guard let sampleList = result else {
               completion(-1, error)
                return
            }
            var heartSum = 0.0
            sampleList.forEach{
                guard let sample = $0 as? HKQuantitySample else{ return }
                let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                heartSum += heartRate
            }
            completion(heartSum/Double(sampleList.count), nil)
        }
        healthStore.execute(query)
    }
    
    func readSwimmingStrokeData(start: Date, end: Date, completion: @escaping ([HKSample], Error?) -> Void){
        Logger.debugDescription("")
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) else{ return }
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: datePredicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) { query, result, error in
            
            guard let sampleList = result else {
                print("sample data 안넘어옴")
                completion([], error)
                return
            }
            
            completion(sampleList, nil)
        }
        healthStore.execute(query)
    }
    
    func refineSwimmingStrokeData(start: Date, end: Date, completion: @escaping ([SwimmingStrokeData], Error?) -> Void){
        Logger.debugDescription("")
        var strokeDataList: [SwimmingStrokeData] = []
        readSwimmingStrokeData(start: start, end: end) { sampleList, error in
            for sample in sampleList {
                guard let quantitySample = sample as? HKQuantitySample else {
                    print("stroke data에 잘못된 값이 들어옴")
                    completion([], error)
                    return
                }
                let strokeCount = quantitySample.quantity.doubleValue(for: HKUnit.count())
                let strokeStyleInt = sample.metadata?["HKSwimmingStrokeStyle"] as? Int
                
                let stokeData = SwimmingStrokeData(startDate: sample.startDate,
                                                   endDate: sample.endDate,
                                                   count: Int(strokeCount),
                                                   strokeStyle: strokeStyleInt ?? -1)
                strokeDataList.append(stokeData)
            }
            completion(strokeDataList, nil)
        }
    }
    
    func startObservingNewWorkouts(){
        print("startObservingNewWorkouts")
        Logger.debugDescription("")
        let sampleType =  HKObjectType.workoutType()
        //1. Enable background delivery for workouts
        self.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (success, error) in
            if let unwrappedError = error {
                print("could not enable background delivery: \(unwrappedError)")
            }
            if success {
                print("background delivery enabled")
            }
        }

        //2.  open observer query
        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            self.updateWorkouts() {
                completionHandler()
            }
        }
        healthStore.execute(query)
    }

    func updateWorkouts(completionHandler: @escaping () -> Void) {
        Logger.debugDescription("")
        var anchor: HKQueryAnchor?
        let sampleType =  HKObjectType.workoutType()

        let anchoredQuery = HKAnchoredObjectQuery(type: sampleType, predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) { [unowned self] query, newSamples, deletedSamples, newAnchor, error in
            guard let sempleList = newSamples else {return}
            print("sempleList.first?.startDate ?? Date() = \(sempleList.last?.startDate ?? Date())")
            self.newWorkOutDateSubject.onNext(sempleList.last?.startDate ?? Date())
            self.handleNewWorkouts(new: sempleList)
            anchor = newAnchor
            completionHandler()
        }
        healthStore.execute(anchoredQuery)
    }

    func handleNewWorkouts(new: [HKSample]) {
        print("")
        new.forEach{
            print("new sample added = \($0.startDate)")
        }
    }
    
}
