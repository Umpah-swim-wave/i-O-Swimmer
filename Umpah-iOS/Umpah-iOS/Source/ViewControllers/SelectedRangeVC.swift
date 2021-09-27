//
//  SelectedRangeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import Then

class SelectedRangeVC: UIViewController {
    // MARK: - Properties
    var backgroundView = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
        $0.addTarget(self, action: #selector(dismissWhenTappedBackView), for: .touchUpInside)
    }
    let rangeView = RangeView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    private func configUI() {
        view.backgroundColor = .clear.withAlphaComponent(0)
    }
    
    private func setupLayout() {
        view.addSubviews([backgroundView, rangeView])
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rangeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(195)
        }
    }
    
    @objc
    func dismissWhenTappedBackView() {
        dismiss(animated: true, completion: nil)
    }
}
