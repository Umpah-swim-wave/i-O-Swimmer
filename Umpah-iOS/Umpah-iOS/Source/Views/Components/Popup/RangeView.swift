//
//  RangeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

class RangeView: UIView {
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = "기간 선택"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    let infoLabel = UILabel().then {
        $0.text = "기본값은 가장 최근 기록입니다!"
        $0.font = .systemFont(ofSize: 11)
    }
    let dayButton = UIButton().then {
        $0.setTitle("일간", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.tintColor = .systemTeal
        $0.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
        $0.contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
    }
    let weekButton = UIButton().then {
        $0.setTitle("주간", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.tintColor = .systemTeal
        $0.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
        $0.contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
    }
    let monthButton = UIButton().then {
        $0.setTitle("월간", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.tintColor = .systemTeal
        $0.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
        $0.contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([titleLabel, dayButton, weekButton, monthButton, infoLabel])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        
    }
}
