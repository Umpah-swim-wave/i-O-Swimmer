//
//  HeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import Then
import SnapKit

class HeaderView: UIView {
    // MARK: - Properties
    var recordButton = UIButton().then {
        $0.setTitle("기록", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(touchupRecord), for: .touchUpInside)
    }
    var routineButton = UIButton().then {
        $0.setTitle("루틴", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.addTarget(self, action: #selector(touchupRoutine), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([recordButton,
                     routineButton,
                     bottomCollectionView])
        
        recordButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        routineButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        bottomCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().inset(28)
            $0.width.equalTo(140)
            $0.height.equalTo(3)
        }
    }
    
    // MARK: - @objc
    @objc
    func touchupRecord() {
        print("Record - ing")
        recordButton.setTitleColor(.black, for: .normal)
        routineButton.setTitleColor(.gray, for: .normal)
    }
    
    @objc
    func touchupRoutine() {
        print("Routine - ing")
        routineButton.setTitleColor(.black, for: .normal)
        recordButton.setTitleColor(.gray, for: .normal)
    }
}
