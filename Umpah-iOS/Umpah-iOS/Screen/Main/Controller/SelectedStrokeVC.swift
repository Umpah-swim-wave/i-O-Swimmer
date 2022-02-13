//
//  SelectedStrokeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SelectedStrokeVC: BaseViewController {
    
    // MARK: - properties
    
    private lazy var strokeView = StrokesView(self).then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
        $0.style = strokeStyle
    }
    private var backgroundView = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    var strokeStyle: Stroke = .none
    var sendStrokeStateData: ((Stroke) -> ())?

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configUI() {
        view.backgroundColor = .clear.withAlphaComponent(0)
    }
    
    override func render() {
        view.addSubviews([backgroundView, strokeView])
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        strokeView.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(268)
        }
    }
    
    // MARK: - func
    
    private func bind() {
        backgroundView.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
