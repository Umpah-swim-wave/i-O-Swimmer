//
//  UITableView+.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/06.
//

import UIKit

extension UITableView {
    func registerCustomXib(name: String){
        let xibName = UINib(nibName: name, bundle: nil)
        self.register(xibName, forCellReuseIdentifier: name)
    }
}

extension UITableViewCell {
    func getTableCellIndexPath() -> Int {
        var indexPath = 0
        
        guard let superView = self.superview as? UITableView else {
            return -1
        }
        indexPath = superView.indexPath(for: self)!.row

        return indexPath
    }
}
