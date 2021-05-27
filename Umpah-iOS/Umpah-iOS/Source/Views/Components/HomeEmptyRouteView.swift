//
//  HomeEmptyRouteView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/27.
//

import UIKit
import SnapKit

class HomeEmptyRouteView: UIView {
    private let swimImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        return image
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 등록된 루틴이 없어요!"
        return label
    }()
    
    private let registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("루틴 등록", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 10
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        swimImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(32)
            make.width.equalTo(82)
            make.height.equalTo(39)
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(swimImage.snp.bottom).offset(16)
        }
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            // MARK: - TODO: width값 변경에 따라서 Layout 수정
            make.width.equalTo(100)
            make.height.equalTo(24)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .gray
        layer.cornerRadius = 15
        
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(swimImage)
        addSubview(messageLabel)
        addSubview(registerButton)
    }
}
