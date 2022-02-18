//
//  StrokeTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/11.
//

import UIKit

import SnapKit
import Then

class StrokeTVC: UITableViewCell {
    static let identifier = "StrokeTVC"
    
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 12)
        $0.textColor = .upuhGray
    }
    let strokeView = StrokeView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.layer.borderWidth = 2
        $0.backgroundColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .upuhBackground
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubviews([titleLabel, strokeView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(32)
        }
        
        strokeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
    
}
