//
//  DetailedRoutineView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/27.
//

import UIKit

class DetailedRoutineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}
