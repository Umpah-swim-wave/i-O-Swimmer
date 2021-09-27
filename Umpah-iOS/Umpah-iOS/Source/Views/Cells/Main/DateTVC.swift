//
//  DateTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

class DateTVC: UITableViewCell {
    static let identifier = "DateTVC"
    
    // MARK: - Properties
    let dateLabel = UILabel().then {
        $0.text = "21/09/27"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.addCharacterSpacing(kernValue: 2)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(27)
        }
    }
}
