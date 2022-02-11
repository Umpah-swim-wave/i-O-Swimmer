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
