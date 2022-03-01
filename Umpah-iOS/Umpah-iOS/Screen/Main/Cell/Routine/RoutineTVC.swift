//
//  RoutineTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class RoutineTVC: UITableViewCell, NibLoadableView, ReusableView {

    private enum Level: Int, CaseIterable {
        case beginner
        case intermediate
        case master
        case none
        
        var title: String {
            switch self {
            case .beginner:
                return "초급"
            case .intermediate:
                return "중급"
            case .master:
                return "고급"
            case .none:
                return "레벨"
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .beginner:
                return .upuhBeginner
            case .intermediate:
                return .upuhIntermediate
            case .master:
                return .upuhMaster
            case .none:
                return .upuhGray
            }
        }
    }
    
    //MARK: - properties
    
    private let backgroundContentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: 0), 7)
    }
    private let routineTitleLabel = UILabel().then{
        $0.font = .IBMPlexSansSemiBold(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -0.2)
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
        $0.backgroundColor = .upuhBadgeOrange
        $0.isUserInteractionEnabled = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    private let timeButton = UIButton().then{
        $0.setTitle("1h", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .upuhBadgeOrange
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    private let descriptionLabel = UILabel().then{
        $0.font = .IBMPlexSansText(ofSize: 12)
        $0.textColor = .upuhBlack
        $0.numberOfLines = 2
    }
    let deleteButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 22, height: 22))).then {
        $0.setImage(UIImage(named: "ic_trash"), for: .normal)
    }
    private let disposeBag = DisposeBag()
    var routineOverviewData: RoutineOverviewData?
    
    // MARK: - init
    
    override func awakeFromNib(){
        super.awakeFromNib()
        render()
        configUI()
        bind()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - init
    
    private func configUI(){
        backgroundColor = .upuhBackground
        selectionStyle = .none
    }
    
    private func render(){
        contentView.addSubview(backgroundContentView)
        
        backgroundContentView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(155)
        }
        
        backgroundContentView.addSubviews([routineTitleLabel,
                                           levelButton,
                                           distanceButton,
                                           timeButton,
                                           descriptionLabel,
                                           deleteButton])
        
        routineTitleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(20)
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
            $0.trailing.equalToSuperview().inset(20)
        }
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(routineTitleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                print("touch Delete")
            })
            .disposed(by: disposeBag)
    }
    
    func setContentData(overview: RoutineOverviewData){
        routineOverviewData = overview
        routineTitleLabel.text = overview.title
        routineTitleLabel.addCharacterSpacing(kernValue: -0.2)
        changeLevelButtonStyle(with: overview.level)
        distanceButton.setTitle(overview.getDistanceToString(), for: .normal)
        timeButton.setTitle(overview.getTimeToString(), for: .normal)
        descriptionLabel.text = overview.description
        descriptionLabel.addCharacterSpacing(kernValue: -0.4, lineSpacing: -4.0)
    }
    
    private func changeLevelButtonStyle(with level: Int){
        guard let level = Level(rawValue: level) else { return }
        
        levelButton.setTitle(level.title, for: .normal)
        levelButton.backgroundColor = level.backgroundColor
    }
}
