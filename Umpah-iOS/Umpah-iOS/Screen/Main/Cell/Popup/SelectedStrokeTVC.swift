//
//  SelectedStrokeTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import SnapKit
import Then

final class SelectedStrokeTVC: UITableViewCell {
    
    // MARK: - properties
    
    override var isSelected: Bool {
        willSet {
            checkButton.isHidden = !isSelected
            strokeLabel.textColor = isSelected ? .upuhBlue2 : .upuhBlack
            strokeLabel.font = isSelected ? .IBMPlexSansSemiBold(ofSize: 16) : .IBMPlexSansText(ofSize: 16)
        }
    }
    private let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "checkIcon"), for: .normal)
        $0.isHidden = true
    }
    let strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 16)
        $0.textColor = .upuhBlack
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
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
