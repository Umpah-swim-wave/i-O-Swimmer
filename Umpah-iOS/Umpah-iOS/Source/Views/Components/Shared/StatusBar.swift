//
//  StatusBar.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

class StatusBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        backgroundColor = .clear
    }

}
