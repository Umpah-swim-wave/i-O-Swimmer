//
//  RoutineItemDataModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/06.
//

import Foundation

struct RoutineItemData {
    var stroke: String = "영법입력"
    var distance: Int = 999
    var time : Int = 0
    
    func getTimeToString() -> String{
        let minute = time / 60 < 10 ? "0\(time / 60)" : "\(time / 60))"
        let second = time % 60 < 10 ? "0\(time % 60)" : "\(time % 60)"
        return minute + ":" + second
    }
}
