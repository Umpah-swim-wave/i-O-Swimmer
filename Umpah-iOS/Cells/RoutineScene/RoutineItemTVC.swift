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
    
    private var strokeLabel = UILabel().then{
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
    
    private var lineView = UIView().then {
        $0.backgroundColor = .lightGray
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
            $0.leading.equalToSuperview().inset(191)
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
    }

    public func setRutineItem(item: RoutineItemData){
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
