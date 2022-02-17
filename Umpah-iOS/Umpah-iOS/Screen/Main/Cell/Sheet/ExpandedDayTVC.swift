//
//  ExpandedDayTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import SnapKit
import Then

final class ExpandedDayTVC: UITableViewCell {
    static let identifier = "ExpandedDayTVC"
    
    // MARK: - properties
    
    private var rowLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 13)
        $0.textColor = .upuhBadgeOrange
    }
    private var strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    private let strokeButton = UIButton().then {
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
        $0.addTarget(self, action: #selector(touchUpChangeStroke), for: .touchUpInside)
    }
    private let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let timeLabel = UILabel().then {
        $0.text = "99:99"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let mergeButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_merge"), for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(touchUpMerge), for: .touchUpInside)
    }
    weak var delegate: SelectedButtonDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        contentView.addSubviews([rowLabel, strokeButton, strokeLabel, distanceLabel,
                     velocityLabel, timeLabel, mergeButton])
        
        rowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        strokeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(46)
            $0.centerY.equalToSuperview()
        }
        strokeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(46)
            $0.centerY.equalToSuperview()
        }
        distanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(153)
            $0.centerY.equalToSuperview()
        }
        velocityLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(97)
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(49)
            $0.centerY.equalToSuperview()
        }
        mergeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    func setupLabels(with data: [String], index: Int) {
        let isSingleDigitNumber = (index < 10)
        
        strokeLabel.text = data[index]
        rowLabel.text = isSingleDigitNumber ? "0\(index + 1)" : "\(index + 1)"
        
        if #available(iOS 15, *) {
            let attributeContainer = AttributeContainer([.foregroundColor: UIColor.upuhBlack,
                                                         .font: UIFont.IBMPlexSansText(ofSize: 14)])
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(named: "ic_drop")
            configuration.titlePadding = 0
            configuration.imagePadding = 2
            configuration.baseForegroundColor = .upuhBlack
            configuration.attributedTitle = AttributedString(data[index], attributes: attributeContainer)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            strokeButton.configuration = configuration
        } else {
            strokeButton.setImage(UIImage(named: "ic_drop"), for: .normal)
            strokeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            strokeButton.setTitle(data[index], for: .normal)
            strokeButton.titleLabel?.font = .IBMPlexSansText(ofSize: 14)
            strokeButton.setTitleColor(.upuhBlack, for: .normal)
            strokeButton.sizeToFit()
        }
    }

    func changeCellConfiguration(_ isModified: Bool,_ compareStroke: Bool) {
        if isModified && compareStroke {
            strokeLabel.isHidden = true
            strokeButton.isHidden = false
            mergeButton.isHidden = false
        } else if isModified && !compareStroke {
            strokeLabel.isHidden = true
            strokeButton.isHidden = false
            mergeButton.isHidden = true
        } else {
            strokeLabel.isHidden = false
            strokeButton.isHidden = true
            mergeButton.isHidden = true
        }
    }
    
    // MARK: - Selector
    
    @objc
    private func touchUpChangeStroke() {
        delegate?.didClickedStrokeFilterButton(with: getTableCellIndexPath())
    }
    
    @objc
    private func touchUpMerge() {
        delegate?.didClickedMergeButton(with: getTableCellIndexPath())
    }
}
