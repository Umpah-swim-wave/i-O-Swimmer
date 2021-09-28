//
//  SelectedStrokeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import Then
import SnapKit

class SelectedStrokeVC: UIViewController {
    // MARK: - Properties
    var backgroundView = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
        $0.addTarget(self, action: #selector(dismissWhenTappedBackView), for: .touchUpInside)
    }
    let strokeView = StrokesView().then {
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
}
