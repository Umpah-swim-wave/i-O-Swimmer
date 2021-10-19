//
//  SelectedRangeDelegate.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import Foundation

protocol SelectedRangeDelegate: class {
    func didClickedRangeButton()
    func didClickedStrokeButton(indexPath: Int)
    func didClickedMergeButton(indexPath: Int)
}

extension SelectedRangeDelegate {
    func didClickedRangeButton() {
        
    }
    
    func didClickedMergeButton(indexPath: Int = 0) {
        
    }
}
