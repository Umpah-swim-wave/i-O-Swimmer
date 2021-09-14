//
//  RoutineViewModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import Foundation
import RxSwift

class RoutineViewModel {
    
    public var routineList: [String : [RoutineItemData]] = [:]
    public var routineSubject: BehaviorSubject<[String : [RoutineItemData]]>?
    public var routineSetTitleList : [String] = []
    
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
        routineSubject = BehaviorSubject<[String : [RoutineItemData]]>(value: routineList)
    }
    
    
    public func addRoutineItem(title: String, item: RoutineItemData){
        routineList[title]?.append(item)
    }
    
    public func modifyRoutineItem(){
        
    }
    
    public func deleteRoutineItem(title: String, index: Int){
        routineList[title]?.remove(at: index)
    }
    
    public func swapRutineItems(_ routineTitle: String, _ i: Int, _ j: Int){
        routineList[routineTitle]?.swapAt(i, j)
    }
    
    public func getRoutineDataList(title: String) -> [RoutineItemData]{
        print("???????????????????????")
        print(routineList[title])
        print("넘겨줘야함")
        return routineList[title] ?? []
    }
}
