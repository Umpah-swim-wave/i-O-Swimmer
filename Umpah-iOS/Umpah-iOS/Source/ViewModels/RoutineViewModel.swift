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
    
}
