//
//  RoutineTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/12.
//

import UIKit

class RoutineTVC: UITableViewCell {

    static let identifier = "RoutineTVC"
    public var routineOverviewData: RoutineOverviewData?
    //MARK: UI Component
    private let backgroundContentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: 0), 7)
    }
    
    private let routineTitleLabel = UILabel().then{
        $0.font = .IBMPlexSansSemiBold(ofSize: 14)
        $0.addCharacterSpacing(kernValue: 0.2)
    }
    
    private let levelButton = UIButton().then{
        $0.setTitle("레벨", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.upuhBlack, for: .normal)
        $0.backgroundColor = .upuhBeginner
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let distanceButton = UIButton().then{
        $0.setTitle("1km", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .upuhOrange
        $0.isUserInteractionEnabled = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let timeButton = UIButton().then{
        $0.setTitle("1h", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .upuhOrange
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let descriptionLabel = UILabel().then{
        $0.font = .IBMPlexSansText(ofSize: 12)
        $0.numberOfLines = 2
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupLayout()
        setCellAttribute()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setCellAttribute(){
        backgroundColor = .upuhBackground
        selectionStyle = .none
        
    }
    
    public func setContentData(overview: RoutineOverviewData){
        routineOverviewData = overview
        routineTitleLabel.text = overview.title
        changeLevelButtonStyle(level: overview.level)
        distanceButton.setTitle(overview.getDistanceToString(), for: .normal)
        timeButton.setTitle(overview.getTimeToString(), for: .normal)
        descriptionLabel.text = overview.description
    }
    
    func changeLevelButtonStyle(level: Int){
        switch level {
        case 0:
            levelButton.setTitle("초급", for: .normal)
            levelButton.backgroundColor = .upuhBeginner
        case 1:
            levelButton.setTitle("중급", for: .normal)
            levelButton.backgroundColor = .upuhIntermediate
        case 2:
            levelButton.setTitle("고급", for: .normal)
            levelButton.backgroundColor = .upuhMaster
        default:
            levelButton.setTitle("레벨", for: .normal)
            levelButton.backgroundColor = .upuhGray
        }
    }
    
    func setupLayout(){
        addSubview(backgroundContentView)
        
        backgroundContentView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(152)
        }
        
        backgroundContentView.addSubviews([routineTitleLabel,
                                           levelButton,
                                           distanceButton,
                                           timeButton,
                                           descriptionLabel])
        
        routineTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        levelButton.snp.makeConstraints{
            $0.top.equalTo(routineTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(routineTitleLabel.snp.leading)
            $0.height.equalTo(24)
        }
        
        distanceButton.snp.makeConstraints{
            $0.centerY.equalTo(levelButton.snp.centerY)
            $0.leading.equalTo(levelButton.snp.trailing).offset(8)
            $0.height.equalTo(24)
        }
        
        timeButton.snp.makeConstraints{
            $0.centerY.equalTo(levelButton.snp.centerY)
            $0.leading.equalTo(distanceButton.snp.trailing).offset(8)
            $0.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(timeButton.snp.bottom).offset(18)
            $0.leading.equalTo(routineTitleLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
//    func updateFirstLayout(){
//        backgroundContentView.snp.updateConstraints{
//            $0.top.equalToSuperview().inset(24)
//        }
//    }
}

