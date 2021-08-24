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
        
        let distanceIconImage = UIImageView().then {
            $0.backgroundColor = .systemOrange
        }
        let distanceTitle = UILabel().then {
            $0.text = "DISTANCE"
            $0.textColor = .systemOrange
            $0.font = .boldSystemFont(ofSize: 8)
            $0.addCharacterSpacing(kernValue: 2)
        }
        let divideLine = UIView().then {
            $0.backgroundColor = .lightGray
        }
        let timeIconImage = UIImageView().then {
            $0.backgroundColor = .systemOrange
        }
        let timeTitle = UILabel().then {
            $0.text = "TIME"
            $0.textColor = .systemOrange
            $0.font = .boldSystemFont(ofSize: 8)
            $0.addCharacterSpacing(kernValue: 2)
        }
        
        $0.addSubviews([distanceIconImage, distanceTitle, divideLine,
                        timeIconImage, timeTitle])
        distanceIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(32)
            $0.width.equalTo(20)
            $0.height.equalTo(17.5)
        }
        distanceTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalTo(distanceIconImage.snp.trailing).offset(6)
        }
        divideLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        timeIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalTo(divideLine.snp.trailing).offset(30)
            $0.width.height.equalTo(20)
        }
        timeTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalTo(timeIconImage.snp.trailing).offset(6)
        }
    }
    let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        
        let kcalIconImage = UIImageView().then {
            $0.backgroundColor = .systemOrange
        }
        let heartIconImage = UIImageView().then {
            $0.backgroundColor = .systemOrange
        }
        let divideLine = UIView().then {
            $0.backgroundColor = .lightGray
        }
        
        $0.addSubviews([kcalIconImage, heartIconImage, divideLine])
        kcalIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(32)
            $0.width.equalTo(24)
            $0.height.equalTo(26)
        }
        divideLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        heartIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23)
            $0.leading.equalTo(divideLine.snp.trailing).offset(22)
            $0.width.equalTo(24)
            $0.height.equalTo(22)
        }
    }
    let distanceLabel = UILabel().then {
        $0.text = "5.4km"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 35)
        $0.changeCharacterAttribute(words: ["km"], size: 22, kernValue: 1)
    }
    let timeLabel = UILabel().then {
        $0.text = "2h 11m"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 35)
        $0.changeCharacterAttribute(words: ["h", "m"], size: 22, kernValue: -0.1)
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
        topView.addSubviews([distanceLabel, timeLabel])
        
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
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalToSuperview().inset(32)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalTo(topView.snp.centerX).offset(30)
        }
    }
}
