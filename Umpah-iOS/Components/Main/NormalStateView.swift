//
//  NormalStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit

class NormalStateView: UIView {
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = "TOTAL"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
    }
    let kilometerLabel = UILabel().then {
        $0.text = "13.7 km"
        $0.font = .boldSystemFont(ofSize: 24)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        addSubviews([titleLabel, kilometerLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46)
            $0.leading.equalToSuperview().inset(32)
        }
        
        kilometerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(32)
        }
    }
}
