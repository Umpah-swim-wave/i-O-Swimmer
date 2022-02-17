//
//  RoutineFilterView.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/13.
//

import UIKit

import SnapKit
import Then

final class RoutineFilterView: BaseView {
    
    // MARK: - properties
    
    var levelButton = UIButton()
    var exceptionButton = UIButton()
    var distanceOrderButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_upArrow"), for: .normal)
        $0.backgroundColor = .upuhBlue.withAlphaComponent(0.1)
    }
    var levelText = "레벨"
    var exceptionStrokeText = "제외할 영법"
    
    override func render() {
        addSubviews([levelButton,
                     exceptionButton,
                     distanceOrderButton])
        
        levelButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.equalToSuperview().offset(18)
            $0.width.equalTo(79)
        }
        
        exceptionButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.equalTo(levelButton.snp.trailing).offset(8)
        }
        
        distanceOrderButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-15)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(91)
        }
    }
    
    override func configUI() {
        backgroundColor = .clear
    }
    
    func setupRoutineHeader() {
        setAttributeRoutineButton(button: levelButton, title: levelText)
        setAttributeRoutineButton(button: exceptionButton, title: exceptionStrokeText)
        setAttributeRoutineButton(button: distanceOrderButton, title: "거리순")
    }
    
    private func setAttributeRoutineButton(button: UIButton, title: String) {
        button.backgroundColor = .clear
        button.semanticContentAttribute = .forceRightToLeft
        button.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.title = title
            configuration.image = UIImage(named: "plus")
            configuration.titlePadding = 0
            configuration.imagePadding = 4
            configuration.baseForegroundColor = .upuhGreen
            configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.upuhGreen, NSAttributedString.Key.font: UIFont.IBMPlexSansSemiBold(ofSize: 14)]))
            button.configuration = configuration
        } else {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.upuhGreen, for: .normal)
            button.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
            button.setImage(UIImage(named: "plus"), for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        }
        
        if button == levelButton && title != "레벨" {
            setFilterButton(button: levelButton, title: title)
        }
        
        if button == exceptionButton && title != "제외할 영법" {
            setFilterButton(button: exceptionButton, title: title)
        }
    }
    
    private func setFilterButton(button: UIButton, title: String) {
        button.setImage(UIImage(named: "xmark"), for: .normal)
        button.backgroundColor = .white
        
        if #available(iOS 15, *) {
            button.configuration?.title = title
            button.configuration?.baseForegroundColor = .upuhGreen
            button.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.upuhGreen, NSAttributedString.Key.font: UIFont.IBMPlexSansSemiBold(ofSize: 14)]))
        } else {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        }
    }
    
    func changeDistanceButton(){
        let isUpArrow = distanceOrderButton.imageView?.image == UIImage(named: "ic_upArrow")
        let newImage = isUpArrow ? UIImage(named: "ic_downArrow") : UIImage(named: "ic_upArrow")
        distanceOrderButton.setImage(newImage, for: .normal)
    }
}
