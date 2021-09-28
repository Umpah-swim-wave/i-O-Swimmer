//
//  SelectedRangeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import Then

class SelectedRangeVC: UIViewController {
    // MARK: - Properties
    let rangeView = RangeView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    private func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private func setupLayout() {
        view.addSubview(rangeView)
        
        rangeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(195)
        }
    }
}
