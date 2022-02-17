//
//  NormalStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import SnapKit
import Then

final class NormalStateView: BaseView {
    
    // MARK: - properties
    
    private let titleLabel = UILabel().then {
        $0.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.textColor = .upuhGreen
    }

    override func render() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - func
    
    func setupTitle(to title: String) {
        titleLabel.text = title
    }
}
