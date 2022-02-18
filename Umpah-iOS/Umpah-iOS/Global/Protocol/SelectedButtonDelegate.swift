//
//  SelectedButtonDelegate.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import Foundation

protocol SelectedButtonDelegate: AnyObject {
    func didClickedPeriodFilterButton()
    func didClickedStrokeFilterButton(with indexPath: Int)
    func didClickedStrokeButton(with indexPath: Int)
    func didClickedMergeButton(with indexPath: Int)
}

extension SelectedButtonDelegate {
    func didClickedPeriodFilterButton() { }
    func didClickedStrokeFilterButton(with indexPath: Int = 0) { }
    func didClickedStrokeButton(with indexPath: Int = 0) { }
    func didClickedMergeButton(with indexPath: Int = 0) { }
}
