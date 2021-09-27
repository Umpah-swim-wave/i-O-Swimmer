//
//  FilterCVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

import Then

class FilterCVC: UICollectionViewCell {
    static let identifier = "FilterCVC"
    
    // MARK: - Properties
    let filterButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.setTitleColor(.init(red: 129/255, green: 151/255, blue: 154/255, alpha: 1.0), for: .normal)
        $0.tintColor = .init(red: 129/255, green: 151/255, blue: 154/255, alpha: 1.0)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        filterButton.setTitle("", for: .normal)
    }
    
    override func layoutSubviews() {
        filterButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .clear
        layer.cornerRadius = 22
        layer.borderColor = UIColor.init(red: 78/255, green: 149/255, blue: 185/255, alpha: 0.15).cgColor
        layer.borderWidth = 2
        
        addSubview(filterButton)
    }
}
