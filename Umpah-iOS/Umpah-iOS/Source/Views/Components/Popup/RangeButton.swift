//
//  RangeButton.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

class RangeButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            setBackgroundColor(isSelected ? .lightGray : .white, for: .normal)
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        configUI()
        
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        clipsToBounds = true
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        setTitleColor(.systemTeal, for: .normal)
        layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 24
        contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
    }
}
