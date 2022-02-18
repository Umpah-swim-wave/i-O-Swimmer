//
//  DateTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import SnapKit
import Then

final class DateTVC: UITableViewCell {
    
    // MARK: - properties
    
    private let dateLabel = UILabel().then {
        $0.textColor = .upuhGreen
    }
    
    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .upuhBackground
        selectionStyle = .none
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(27)
        }
    }
    
    func setupDateLabel(with dateText: String) {
        dateLabel.text = dateText
        dateLabel.addCharacterSpacing(kernValue: 2)
        
        let isSpecificWeek = (dateText == "이번주" || dateText == "지난주")
        dateLabel.font = isSpecificWeek ? .IBMPlexSansSemiBold(ofSize: 16) : .nexaBold(ofSize: 16)
    }
}
