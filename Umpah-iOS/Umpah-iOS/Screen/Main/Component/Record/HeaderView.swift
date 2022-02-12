//
//  HeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HeaderView: UIView {
    
    // MARK: - properties
    
    var pressedTabIsRecord : ((Bool) -> ())?
    
    private var recordButton = UIButton().then {
        $0.setTitle("기록", for: .normal)
        $0.setTitleColor(.upuhBlack, for: .selected)
        $0.setTitleColor(.upuhGreen, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.isSelected = true
    }
    private var routineButton = UIButton().then {
        $0.setTitle("루틴", for: .normal)
        $0.setTitleColor(.upuhBlack, for: .selected)
        $0.setTitleColor(.upuhGreen, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansRegular(ofSize: 16)
        $0.isSelected = false
    }
    private var bottomView = UIView().then {
        $0.backgroundColor = .upuhBlack
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        addSubviews([recordButton, routineButton, bottomView])
        
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
    
    private func configUI() {
        backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    private func bind() {
        recordButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.recordButton.isSelected = true
                self.routineButton.isSelected = false
                self.changeButtonTitleLabelFont(isRecord: true)
                self.moveThePositionOfBottomView(with: 0)
                self.pressedTabIsRecord?(true)
            })
            .disposed(by: disposeBag)
        
        routineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.routineButton.isSelected = true
                self.recordButton.isSelected = false
                self.changeButtonTitleLabelFont(isRecord: false)
                self.moveThePositionOfBottomView(with: 70)
                self.pressedTabIsRecord?(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeButtonTitleLabelFont(isRecord: Bool) {
        recordButton.titleLabel?.font = isRecord ? .IBMPlexSansSemiBold(ofSize: 16) : .IBMPlexSansRegular(ofSize: 16)
        routineButton.titleLabel?.font = isRecord ? .IBMPlexSansRegular(ofSize: 16) : .IBMPlexSansSemiBold(ofSize: 16)

    }
    
    private func moveThePositionOfBottomView(with translationX: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: translationX, y: 0)
        })
    }
}
