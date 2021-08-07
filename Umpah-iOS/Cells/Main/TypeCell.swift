//
//  TypeCell.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/08.
//

import UIKit

import Then
import SnapKit

class TypeCell: UICollectionViewCell {
    static let identifier = "TypeCell"
    
    override var isSelected: Bool {
        didSet {
            typeLabel.textColor = isSelected ? .black : .lightGray
            backgroundColor = isSelected ? .gray : .systemGray5
        }
    }
    var typeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTypeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTypeCell() {
        layer.cornerRadius = 8
        
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
