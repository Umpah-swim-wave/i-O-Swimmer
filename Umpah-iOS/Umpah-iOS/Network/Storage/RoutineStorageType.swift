//
//  SwimmingStorage.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/28.
//

import Foundation
import RxSwift

protocol RoutineStorageType {
    
    @discardableResult
    func createRoutine(setTitle: String) -> Observable<RoutineItemData>
    
    @discardableResult
    func getRoutineList() -> Observable<[String: [RoutineItemData]]>
    
    @discardableResult
    func update(setTitle: String, index: Int, newItem: RoutineItemData) -> Observable<RoutineItemData>
    
    func swapRoutineItems(setTitle: String, sourceIndex: Int, destinationIndex: Int)
    
    func delete(setTitle: String, index: Int)
}

