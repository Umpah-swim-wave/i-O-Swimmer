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
    let titleLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .boldSystemFont(ofSize: 12)
        $0.addCharacterSpacing(kernValue: 2)
    }
    let detailView = DetailView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .init(red: 223/255, green: 231/255, blue: 233/255, alpha: 1.0)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        sendSubviewToBack(contentView)
        
        addSubviews([titleLabel, detailView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
