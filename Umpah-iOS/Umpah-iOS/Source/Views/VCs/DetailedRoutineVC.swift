//
//  DetailedRoutineVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/27.
//

import UIKit
import SnapKit

class DetailedRoutineVC: UIViewController {
    private let embededView = DetailedRoutineView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
    }

    private func setupConfigure() {
        view.addSubview(embededView)
        embededView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.size.height/2)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(UIScreen.main.bounds.size.height)
        }
    }
}
