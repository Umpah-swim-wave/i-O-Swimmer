//
//  FilterCVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

import Then
import SnapKit

class FilterCVC: UICollectionViewCell {
    static let identifier = "FilterCVC"
    
    // MARK: - Properties
    let filterButton = UIButton().then {
        $0.setTitleColor(.upuhGreen, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isUserInteractionEnabled = false
    }
    let backView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.layer.borderWidth = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .clear
        layer.cornerRadius = 22
        
        setViewShadow(backView: backView, cornerRadius: 22)
        
        addSubviews([backView, filterButton])
    }
}