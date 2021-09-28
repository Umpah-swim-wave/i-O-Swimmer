//
//  TopView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import Then
import SnapKit

class TopView: UIView {
    // MARK: - Properties
    var titleLabel = UILabel().then {
        $0.text = "어푸님!\n수영하기 좋은 날이에요!"
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .medium)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(49)
            $0.leading.equalToSuperview().inset(36)
        }
    }
}
