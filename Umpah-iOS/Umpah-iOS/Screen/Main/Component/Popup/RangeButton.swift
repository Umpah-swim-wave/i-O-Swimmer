//
//  RangeButton.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

final class RangeButton: UIButton {
    
    // MARK: - properties
    
    override var isSelected: Bool {
        didSet {
            setBackgroundColor(isSelected ? .upuhBlue.withAlphaComponent(0.15) : .white, for: .normal)
            layer.borderColor = isSelected ? UIColor.upuhBlue.withAlphaComponent(0.2).cgColor : UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        }
    }
    private var title: String
    
    // MARK: - init

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        constraint(widthAnchor, constant: 62)
        constraint(heightAnchor, constant: 40)
    }
    
    private func configUI() {
        contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
        clipsToBounds = true

        titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
        setTitle(title, for: .normal)
        setTitleColor(.upuhGreen, for: .normal)

        layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 21
    }
}
