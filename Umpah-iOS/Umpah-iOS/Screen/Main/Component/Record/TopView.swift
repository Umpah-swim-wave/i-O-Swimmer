//
//  TopView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import SnapKit
import Then

final class TopView: BaseView {
    
    // MARK: - properties
    
    var nameLabel = UILabel().then {
        $0.text = "어푸님,"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 20)
    }
    var titleLabel = UILabel().then {
        $0.text = "수영하기 좋은 날이에요!"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansRegular(ofSize: 18)
    }
    
    override func render() {
        addSubviews([nameLabel, titleLabel])
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(49)
            $0.leading.equalToSuperview().inset(36)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(36)
        }
    }
    
    override func configUI() {
        backgroundColor = .clear
    }
}
