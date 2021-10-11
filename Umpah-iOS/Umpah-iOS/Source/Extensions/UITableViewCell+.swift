//
//  UITableViewCell+.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/06.
//

import UIKit

extension UITableViewCell{
    func getTableCellIndexPathRow() -> Int {
        guard let superView = self.superview as? UITableView else { return -1 }
        return superView.indexPath(for: self)!.row
    }
}

