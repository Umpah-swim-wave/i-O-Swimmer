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
