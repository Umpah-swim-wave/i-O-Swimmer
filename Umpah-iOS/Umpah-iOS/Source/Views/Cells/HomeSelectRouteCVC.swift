//
//  HomeSelectRouteCVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/25.
//

import UIKit

class HomeSelectRouteCVC: UICollectionViewCell {
    static let identifier = "HomeSelectRouteCVC"

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
    }
    
    private func setupConfigure() {
        self.makeRoundedCellWithShadow(background: backView)
    }
}
