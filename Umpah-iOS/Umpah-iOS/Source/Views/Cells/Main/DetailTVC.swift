//
//  DetailTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Then
import SnapKit
import Charts

class DetailTVC: UITableViewCell {
    static let identifier = "DetailTVC"
    
    // MARK: - Properties
    let dateLabel = UILabel().then {
        $0.text = "2021.09.05"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.addCharacterSpacing(kernValue: 2)
    }
    let titleLabel = UILabel().then {
        $0.text = "OVERVIEW"
        $0.textColor = .gray
        $0.font = .boldSystemFont(ofSize: 12)
        $0.addCharacterSpacing(kernValue: 2)
    }
    let titleStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 24
    }
    let detailView = DetailView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        sendSubviewToBack(contentView)
        
        addSubviews([titleStack, detailView])
        titleStack.addArrangedSubview(dateLabel)
        titleStack.addArrangedSubview(titleLabel)
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37)
            $0.leading.equalToSuperview().inset(32)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(49)
        }
    }
}
