//
//  States.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import Foundation

enum CardViewState {
    case base
    case expanded
    case normal
    case fail
}

enum CurrentState {
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

enum Stroke {
    case freestyle
    case breaststroke
    case backstroke
    case butterfly
    case none
}
