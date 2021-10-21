//
//  UITableView+.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/06.
//

import UIKit

extension UITableView {
    
    /// 삭제해야할 Xib 코드
    func registerCustomXib(name: String){
        let xibName = UINib(nibName: name, bundle: nil)
        self.register(xibName, forCellReuseIdentifier: name)
    }
    
    /// 새로 추가된 Xib 코드
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// 셀을 꺼내 드는 메서드
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with Identifier: \(T.reuseIdentifier)")
        }
        return cell
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
