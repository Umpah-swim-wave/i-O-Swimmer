//
//  HomeMainHeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/24.
//

import UIKit
import SnapKit

class HomeMainHeaderView: UIView {
    // MARK: - TODO: UserDefaults로 이름 가져오기
    private let standard = UserDefaults.standard
    
    lazy private var largeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.standard.string(forKey: "userName") ?? "한솔")님 안녕하세요"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴부터 등록해 볼까요?"
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flame.fill")
        return imageView
    }()
    
    // MARK: - TODO: Naming 다시 잡아주기
    private let personalButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
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
        super.layoutSubviews()
        
        largeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(52)
            make.leading.equalTo(self.snp.leading).inset(25)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(largeTitleLabel.snp.bottom)
            make.leading.equalTo(largeTitleLabel)
        }
        settingButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).inset(11)
            make.top.equalTo(self.snp.top).inset(8)
        }
        personalButton.snp.makeConstraints { make in
            make.trailing.equalTo(settingButton.snp.leading).offset(-11)
            make.top.equalTo(settingButton)
        }
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(personalButton.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).inset(44)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .none?.withAlphaComponent(0)
        
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(largeTitleLabel)
        addSubview(subTitleLabel)
        addSubview(characterImageView)
        addSubview(personalButton)
        addSubview(settingButton)
    }
}
