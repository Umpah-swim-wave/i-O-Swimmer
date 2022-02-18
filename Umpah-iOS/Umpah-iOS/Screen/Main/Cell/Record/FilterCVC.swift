//
//  FilterCVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

import SnapKit
import Then

final class FilterCVC: UICollectionViewCell {
    
    // MARK: - properties
    
    private let filterButton = UIButton().then {
        $0.setTitleColor(.upuhGreen, for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isUserInteractionEnabled = false
    }
    private let backView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.layer.borderWidth = 2
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
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
    
    // MARK: - func
    
    private func render() {
        addSubviews([backView, filterButton])
    }
    
    private func configUI() {
        backgroundColor = .clear
        layer.cornerRadius = 22
        
        setViewShadow(backView: backView, cornerRadius: 22)
    }
    
    @available(iOS 15.0, *)
    private func setupConfigurationButton(image: String,
                                          titlePadding: CGFloat,
                                          imagePadding: CGFloat,
                                          backgroundColor: UIColor,
                                          title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: image)
        configuration.titlePadding = titlePadding
        configuration.imagePadding = imagePadding
        configuration.baseForegroundColor = backgroundColor
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.upuhGreen, NSAttributedString.Key.font: UIFont.IBMPlexSansSemiBold(ofSize: 14)]))
        return configuration
    }
    
    func setupFilterButton(image: String,
                                   titlePadding: CGFloat,
                                   imagePadding: CGFloat,
                                   title: String) {
        if #available(iOS 15, *) {
            filterButton.configuration = setupConfigurationButton(image: image,
                                                                  titlePadding: titlePadding,
                                                                  imagePadding: imagePadding,
                                                                  backgroundColor: .upuhGreen,
                                                                  title: title)
        } else {
            filterButton.setTitle(title, for: .normal)
            filterButton.setImage(UIImage(named: image), for: .normal)
        }
    }
}
