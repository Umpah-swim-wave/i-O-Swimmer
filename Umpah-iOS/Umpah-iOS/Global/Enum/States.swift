//
//  States.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import Foundation

enum CardViewState {
    case expanded
    case normal
    case fail
}

enum CurrentMainViewState: Int, CaseIterable {
    case base
    case day
    case week
    case month
    case routine
    
    var title: String {
        switch self {
        case .week:
            return "요일별 기록 보기"
        case .month:
            return "주간별 기록 보기"
        case .routine:
            return "어푸가 추천하는 루틴 보기"
        default:
            return "랩스 기록 보기"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .day,
             .base:
            return false
        default:
            return true
        }
    }
}

enum RangeState {
    case day
    case week
    case month
    case none
}

enum Stroke: Int, CaseIterable {
    case freestyle = 1
    case breaststroke = 2
    case backstroke = 3
    case butterfly = 4
    case none = 0
}
