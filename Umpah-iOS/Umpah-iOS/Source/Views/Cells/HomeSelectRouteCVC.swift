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
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var kiloLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
    }
    
    private func setupConfigure() {
        self.makeRoundedCellWithShadow(background: backView)
        routeImageView.layer.cornerRadius = 15
    }
}
