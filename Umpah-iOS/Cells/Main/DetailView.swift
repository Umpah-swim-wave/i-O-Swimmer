//
//  DetailView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Then
import SnapKit

class DetailView: UIView {
    // MARK: - Properties
    let topView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    private func setupLayout() {
        addSubviews([topView, bottomView])
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(110)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(topView)
            $0.height.equalTo(70)
            $0.bottom.equalToSuperview()
        }
    }
}
