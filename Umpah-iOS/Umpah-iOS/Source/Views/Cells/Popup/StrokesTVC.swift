//
//  StrokesTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import Then
import SnapKit

class StrokesTVC: UITableViewCell {
    static let identifier = "StrokesTVC"
    
    override var isSelected: Bool {
        willSet {
            checkButton.isHidden = !isSelected
            strokeLabel.textColor = isSelected ? .upuhBlue2 : .upuhBlack
        }
    }
    
    // MARK: - Properties
    let strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 16)
        $0.textColor = .upuhBlack
    }
    let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([strokeLabel, checkButton])
        
        strokeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(32)
            $0.height.width.equalTo(24)
        }
    }
}