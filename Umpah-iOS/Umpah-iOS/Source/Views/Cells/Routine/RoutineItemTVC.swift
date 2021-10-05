//
//  RoutineItemTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/05.
//

import UIKit
import SnapKit
import Then

class RoutineItemTVC: UITableViewCell {
    static let identifier = "RoutineItemTVC"
    
    public var selectStorke: (() -> ())?
    private var routineItem: RoutineItemData?
    
    public var strokeButton = UIButton().then{
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        $0.setTitleColor(.upuhBlack, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = .IBMPlexSansRegular(ofSize: 14)
    }
    
    private var distanceLabel = UILabel().then{
        $0.font = .IBMPlexSansRegular(ofSize: 14)
        $0.textColor = .upuhBlack
    }
 
    
    private var timeLabel = UILabel().then{
        $0.font = .IBMPlexSansRegular(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    
    public var lineView = UIView().then {
        $0.backgroundColor = .upuhSubGray
    }
    
    public var isEditingMode: Bool = false {
        didSet{
            if isEditingMode{
                changeLayoutAtEditingMode()
                strokeButton.setImage(UIImage(named: "chevronDown"), for: .normal)
            }else{
                turnToInitLayout()
                strokeButton.setImage(nil, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        addActions()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setRoutineItem(item: RoutineItemData, isEditing: Bool){
        routineItem = item
        strokeButton.setTitle(item.stroke, for: .normal)
        distanceLabel.text = item.distance + "m"
        timeLabel.text = item.getTimeToString()
        isEditingMode = isEditing
    }
    
    private func setContentText(){
        guard let item = routineItem else {
            print("넘겨져온 item이 없음")
            return
        }
        strokeButton.setTitle(item.stroke, for: .normal)
        distanceLabel.text = item.distance + "m"
        timeLabel.text = item.getTimeToString()
    }
    
    func addActions(){
        strokeButton.addTarget(self, action: #selector(touchUpToselectStorke), for: .touchUpInside)
    }
    
    @objc
    func touchUpToselectStorke(){
        print("touchUpToselectStorke")
        selectStorke?()
    }
}


//MARK: UI
extension RoutineItemTVC {
    private func setupLayout(){
        addSubviews([strokeButton,
                     distanceLabel,
                     timeLabel,
                     lineView])

        strokeButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(108)
        }
        
        distanceLabel.snp.makeConstraints{
            $0.centerY.equalTo(strokeButton.snp.centerY)
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-37)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(strokeButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        print("Editing = \(isEditingMode)")
        print("showsReorderControl = \(showsReorderControl)")
        if showsReorderControl{
            changeLayoutAtEditingMode()
        }else{
            turnToInitLayout()
        }
    }
    
    public func changeLayoutAtEditingMode(){
        strokeButton.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(46)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-55)
        }
    }
    
    public func turnToInitLayout(){
        strokeButton.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(24)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
