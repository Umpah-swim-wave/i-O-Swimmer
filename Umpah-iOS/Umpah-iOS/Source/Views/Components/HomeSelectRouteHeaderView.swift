//
//  HomeSelectRouteHeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/25.
//

import UIKit
import SnapKit

class HomeSelectRouteHeaderView: UICollectionReusableView {
    static let identifier = "HomeSelectRouteHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 선택하기"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(-8)
            make.leading.equalTo(self.snp.leading).inset(24)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .none?.withAlphaComponent(0)
        
        addSubview(titleLabel)
    }
}
