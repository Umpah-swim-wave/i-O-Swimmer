//
//  HomeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/10.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    let mainHeaderView = HomeMainHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }
    
    private func setupConfigure() {
        view.addSubview(mainHeaderView)
        mainHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(128)
        }
    }
    
}
