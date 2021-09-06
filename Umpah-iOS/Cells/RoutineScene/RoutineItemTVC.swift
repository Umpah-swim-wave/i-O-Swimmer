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
    
    private var routineItem: RoutineItemData?
    
    public var strokeLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    private var distanceLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    private var timeLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    public var lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    public var isEditingMode: Bool = false {
        didSet{
            if isEditingMode{
                print("strokeLabel \(strokeLabel.text)")
                changeLayoutAtEditingMode()
            }else{
                turnToInitLayout()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        setContentText()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    public func setRoutineItem(item: RoutineItemData){
        routineItem = item
        print("routineItem = \(routineItem)")
        strokeLabel.text = item.stroke
        distanceLabel.text = item.distance + "m"
        timeLabel.text = item.getTimeToString()
    }
    
    private func setContentText(){
        guard let item = routineItem else {
            print("넘겨져온 item이 없음")
            return
        }
        strokeLabel.text = item.stroke
        distanceLabel.text = item.distance + "m"
        timeLabel.text = item.getTimeToString()
    }
}


//MARK: UI
extension RoutineItemTVC {
    private func setupLayout(){
        addSubviews([strokeLabel,
                     distanceLabel,
                     timeLabel,
                     lineView])
        
        strokeLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(24)
        }
        
        distanceLabel.snp.makeConstraints{
            $0.centerY.equalTo(strokeLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(107)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(strokeLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(32)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
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
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(46)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(50)
        }
        
    }
    
    public func turnToInitLayout(){
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(24)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(32)
        }
    }
}
