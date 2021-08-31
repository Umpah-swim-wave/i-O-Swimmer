//
//  ExpandedDayTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class ExpandedDayTVC: UITableViewCell {
    static let identifier = "ExpandedDayTVC"
    
    // MARK: - Properties
    let rowLabel = UILabel().then {
        $0.text = "01"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .orange
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func setupLayout() {
        addSubview(rowLabel)
        
        rowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(1)
        }
    }

}
