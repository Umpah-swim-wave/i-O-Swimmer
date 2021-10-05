//
//  RoutineStorage.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/28.
//

import Foundation
import RxSwift

class RoutineStorage: RoutineStorageType{
    
    public var routineList: [String : [RoutineItemData]] = [:]
    public var routineSetTitleList : [String] = []
    
    private lazy var store = BehaviorSubject<[String : [RoutineItemData]]>(value: routineList)
    
    init() {
        initRoutineItems()
    }
    
    private func initRoutineItems(){
        routineSetTitleList = ["warm-up", "main", "cool-down"]
        routineList = ["warm-up" : [RoutineItemData(stroke: "자유영", distance: "90", time: 135),
                                    RoutineItemData(stroke: "자유영", distance: "250", time: 235),
                                    RoutineItemData(stroke: "자유영", distance: "1275", time: 335)] ,
                       "main" : [RoutineItemData(stroke: "배형", distance: "1225", time: 130),
                                 RoutineItemData(stroke: "배형", distance: "1250", time: 131),
                                 RoutineItemData(stroke: "배형", distance: "1275", time: 132),
                                 RoutineItemData(stroke: "배형", distance: "1300", time: 133),
                                 RoutineItemData(stroke: "배형", distance: "1225", time: 134)],
                       "cool-down" : [RoutineItemData(stroke: "접형", distance: "1200", time: 100),
                                 RoutineItemData(stroke: "접형", distance: "1225", time: 200),
                                 RoutineItemData(stroke: "접형", distance: "1250", time: 300),
                                 RoutineItemData(stroke: "접형", distance: "1275", time: 400)]]
    }
    
    
    @discardableResult
    func createRoutine(setTitle: String) -> Observable<RoutineItemData> {
        let routine = RoutineItemData()
        routineList[setTitle]?.append(routine)
        store.onNext(routineList)
        print("-----\(setTitle)-------createRoutine------=\(routineList[setTitle]?.count)----------")
        displayCurrentRoutineItems(setTitle: setTitle)
        return Observable.just(routine)
    }
    
    @discardableResult
    func getRoutineList() -> Observable<[String : [RoutineItemData]]> {
        print("------------getRoutineList----------------")
        return store
    }
    
    @discardableResult
    func update(setTitle: String, index: Int, newItem: RoutineItemData) -> Observable<RoutineItemData> {
        
        routineList[setTitle]?.remove(at: index)
        routineList[setTitle]?.insert(newItem, at: index)
        
        store.onNext(routineList)
        print("------------update----------------")
        displayCurrentRoutineItems(setTitle: setTitle)
        return Observable.just(newItem)
    }
    
    func swapRoutineItems(setTitle: String, sourceIndex: Int, destinationIndex: Int) {
        routineList[setTitle]?.swapAt(sourceIndex, destinationIndex)
        store.onNext(routineList)
        displayCurrentRoutineItems(setTitle: setTitle)
        print("------------swapRoutineItems----------------")
    }
    
    @discardableResult
    func delete(setTitle: String, index: Int){
        routineList[setTitle]?.remove(at: index)
        displayCurrentRoutineItems(setTitle: setTitle)
        print("------------delete----------------")
    }
    
    func displayCurrentRoutineItems(setTitle: String){
        routineList[setTitle]?.forEach{
            print($0)
        }
    }
}
