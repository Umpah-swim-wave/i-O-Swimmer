//
//  DetailTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Charts
import SnapKit
import Then

final class DetailTVC: UITableViewCell {

    // MARK: - properties
    
    private let detailView = DetailView()
    private let titleLabel = UILabel().then {
        $0.textColor = .upuhGray
        $0.font = .nexaBold(ofSize: 12)
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
        contentView.addSubviews([titleLabel, detailView])
        
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
    
    func setupTitleLabel(with state: CurrentMainViewState) {
        switch state {
        case .day, .base:
            titleLabel.text = "OVERVIEW"
        case .week:
            titleLabel.text = "WEEKLY OVERVIEW"
        case .month:
            titleLabel.text = "MONTHLY OVERVIEW"
        default:
            break
        }
        titleLabel.addCharacterSpacing(kernValue: 2)
    }
}
