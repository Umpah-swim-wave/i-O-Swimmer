//
//  BaseView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/20.
//

import UIKit

class BaseView: UIView {

    // MARK: - Initalizing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
        setLocalization()
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // Override Configuration
    }
    
    func setLocalization() {
        // Override Localization
    }
    
    func setData() {
        // Override Set Data
    }
}
