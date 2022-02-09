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
            setBackgroundColor(isSelected ? .upuhBlue.withAlphaComponent(0.15) : .white, for: .normal)
            layer.borderColor = isSelected ? UIColor.upuhBlue.withAlphaComponent(0.2).cgColor : UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        configUI()
        constraint(widthAnchor, constant: 62)
        constraint(heightAnchor, constant: 40)
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        clipsToBounds = true
        titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
        setTitleColor(.upuhGreen, for: .normal)
        layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 21
        contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
    }
}
