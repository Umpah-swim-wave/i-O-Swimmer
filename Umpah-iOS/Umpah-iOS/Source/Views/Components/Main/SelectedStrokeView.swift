//
//  SelectedStrokeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class SelectedStrokeView: UIView {
    // MARK: - Properties
    let selectButton = UIButton().then {
        $0.setTitle("영법 수정하기", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.upuhSubBlue, for: .normal)
        $0.setBackgroundColor(.upuhSubBlue.withAlphaComponent(0.7), for: .highlighted)
        $0.layer.cornerRadius = 23
        $0.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(selectButton)
        
        selectButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.top.equalToSuperview()
        }
    }
}
