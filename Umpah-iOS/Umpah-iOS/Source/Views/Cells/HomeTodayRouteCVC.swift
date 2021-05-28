//
//  HomeTodayRouteCVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/25.
//

import UIKit
import SnapKit

class HomeTodayRouteCVC: UICollectionViewCell {
    static let identifier = "HomeTodayRouteCVC"
    
    private let emptyView = HomeEmptyRouteView()

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
    }
    
    private func setupConfigure() {
        self.makeRoundedCellWithShadow(background: backView)
        
        self.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
