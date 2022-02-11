//
//  ExpandedDayTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class ExpandedDayTVC: UITableViewCell {
    static let identifier = "ExpandedDayTVC"
    
    // MARK: - UI
    var rowLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 13)
        $0.textColor = .upuhBadgeOrange
    }
    var strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    let strokeButton = UIButton().then {
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
        $0.addTarget(self, action: #selector(touchUpChangeStroke), for: .touchUpInside)
    }
    let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let timeLabel = UILabel().then {
        $0.text = "99:99"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let mergeButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_merge"), for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(touchUpMerge), for: .touchUpInside)
    }
    
    weak var delegate: SelectedButtonDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        sendSubviewToBack(contentView)
        addSubviews([rowLabel,
                     strokeButton,
                     strokeLabel,
                     distanceLabel,
                     velocityLabel,
                     timeLabel,
                     mergeButton])
        
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
    
    // MARK: - @objc
    @objc
    private func touchUpChangeStroke() {
        delegate?.didClickedStrokeFilterButton(with: getTableCellIndexPath())
    }
    
    @objc
    private func touchUpMerge() {
        print("can merge")
        delegate?.didClickedMergeButton(with: getTableCellIndexPath())
    }
}
