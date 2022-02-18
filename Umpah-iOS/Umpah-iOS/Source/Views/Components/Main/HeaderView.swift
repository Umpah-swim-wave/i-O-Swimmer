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
    var changeState : ((Bool) -> ())?
    
    var recordButton = UIButton().then {
        $0.setTitle("기록", for: .normal)
        $0.setTitleColor(.upuhBlack, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.addTarget(self, action: #selector(touchupRecord), for: .touchUpInside)
    }
    var routineButton = UIButton().then {
        $0.setTitle("루틴", for: .normal)
        $0.setTitleColor(.upuhGreen, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansRegular(ofSize: 16)
        $0.addTarget(self, action: #selector(touchupRoutine), for: .touchUpInside)
    }
    var bottomView = UIView().then {
        $0.backgroundColor = .upuhBlack
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
                     bottomView])
        
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
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().inset(38)
            $0.width.equalTo(50)
            $0.height.equalTo(3)
        }
    }
    
    // MARK: - @objc
    @objc
    func touchupRecord() {
        print("Record - ing")
        recordButton.setTitleColor(.upuhBlack, for: .normal)
        routineButton.setTitleColor(.upuhGreen, for: .normal)
        recordButton.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        routineButton.titleLabel?.font = .IBMPlexSansRegular(ofSize: 16)
        moveRecordDirection()
        changeState?(false)
    }
    
    @objc
    func touchupRoutine() {
        print("Routine - ing")
        routineButton.setTitleColor(.upuhBlack, for: .normal)
        recordButton.setTitleColor(.upuhGreen, for: .normal)
        routineButton.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        recordButton.titleLabel?.font = .IBMPlexSansRegular(ofSize: 16)
        moveRoutineDirection()
        changeState?(true)
    }
}

// MARK: - Helper
extension HeaderView {
    func moveRecordDirection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.transform = .identity
        })
    }
    
    func moveRoutineDirection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: 70, y: 0)
        })
    }
}
