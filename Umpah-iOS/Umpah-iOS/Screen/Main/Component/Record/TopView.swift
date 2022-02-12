//
//  TopView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import SnapKit
import Then

final class TopView: UIView {
    
    // MARK: - properties
    
    private var nameLabel = UILabel().then {
        $0.text = "어푸님,"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 20)
    }
    private var titleLabel = UILabel().then {
        $0.text = "수영하기 좋은 날이에요!"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansRegular(ofSize: 18)
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
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
    
    private func configUI() {
        backgroundColor = .clear
    }
}
