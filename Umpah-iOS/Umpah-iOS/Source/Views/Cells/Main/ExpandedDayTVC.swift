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
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .orange
    }
    var strokeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    let strokeButton = UIButton().then {
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: "chevron.down")
            configuration.titlePadding = 0
            configuration.imagePadding = 2
            configuration.baseForegroundColor = .black
            configuration.attributedTitle = AttributedString("자유형", attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            $0.configuration = configuration
        } else {
            $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitleColor(.black, for: .normal)
            $0.sizeToFit()
        }
        
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
        $0.addTarget(self, action: #selector(touchUpChangeStroke), for: .touchUpInside)
    }
    let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .systemFont(ofSize: 14)
    }
    let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .systemFont(ofSize: 14)
    }
    let timeLabel = UILabel().then {
        $0.text = "99:99"
        $0.font = .systemFont(ofSize: 14)
    }
    let mergeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        $0.tintColor = .black
        $0.isHidden = true
    }
    
    weak var delegate: SelectedRangeDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        delegate?.didClickedStrokeButton(indexPath: getTableCellIndexPath())
    }
}
