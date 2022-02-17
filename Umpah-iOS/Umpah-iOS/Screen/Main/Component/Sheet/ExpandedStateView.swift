//
//  ExpandedStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit

final class ExpandedStateView: ExpandedStateTableView {
    
    // MARK: - properties
    
    lazy var bottomView = CardBottomButtonView().then {
        $0.backgroundColor = .white
    }
    let titleLabel = UILabel().then {
        $0.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.textColor = .upuhGreen
    }
    
    //MARK: about Routine

    let routineFilterView = RoutineFilterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupModifyButton()
        initRoutineOverViewList()
        setupRoutineFilterActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        addSubviews([titleLabel, listTableView, bottomView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.centerX.equalToSuperview()
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.hasNotch ? 93 : 49)
        }
    }
    
    private func setupModifyButton() {
        bottomView.selectButton.addTarget(self, action: #selector(touchUpModify), for: .touchUpInside)
    }
    
    func changeTableViewLayout() {
        switch state {
        case .base,
             .day:
            deleteRoutineFilterLayout()
            listTableView.snp.updateConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(36)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 93 : 49)
            }
        case .routine:
            setupRoutineFilterLayout()
            listTableView.snp.updateConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(91)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        default:
            deleteRoutineFilterLayout()
            listTableView.snp.updateConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(36)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    func setupRoutineFilterLayout(){
        backgroundColor = .upuhBackground
        listTableView.backgroundColor = .upuhBackground
        self.layer.cornerRadius = 32
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        addSubview(routineFilterView)
        routineFilterView.setupRoutineHeader()
        routineFilterView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(77)
        }
    }
    func deleteRoutineFilterLayout(){
        routineFilterView.removeFromSuperview()
        backgroundColor = .clear
        listTableView.backgroundColor = .clear
    }
    
    private func setupRoutineFilterActions(){
        let presentinglevelAction = UIAction { _ in
            self.presentToModifyElement(elementType: .level)
        }
    
        let presentingStrokeAction = UIAction { _ in
            self.presentToModifyElement(elementType: .exceptStorke)
        }
        
        let changeOrderingDistanceAction = UIAction { _ in
            self.routineFilterView.changeDistanceButton()
        }
        
        routineFilterView.levelButton.addAction(presentinglevelAction, for: .touchUpInside)
        routineFilterView.exceptionButton.addAction(presentingStrokeAction, for: .touchUpInside)
        routineFilterView.distanceOrderButton.addAction(changeOrderingDistanceAction, for: .touchUpInside)
    }
    
    //MARK: 서버통신 후 삭제할 더미 함수
    private func initRoutineOverViewList(){
        for i in 0..<20 {
            var data = RoutineOverviewData()
            data.level = Int.random(in: 0...2)
            upuhRoutineOverViewList.append(data)
        }
        filteredOverViewList = upuhRoutineOverViewList
    }

    private func presentToModifyElement(elementType: ModifyElementType){
        let storyboard = UIStoryboard(name: "ModifyElement", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: ModifyElementVC.identifier) as? ModifyElementVC else {return}
        
        nextVC.elementType = elementType
        nextVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            nextVC.backgroundImage = self.root?.view.asImage()
            nextVC.modalTransitionStyle = .crossDissolve
            self.root?.present(nextVC, animated: true, completion: nil)
        })
    }
    private func applyToFilterData(){
        
    }
    
    private func getLevelText(level: Int) -> String{
        switch level{
        case 0:
            return "초급"
        case 1:
            return "중급"
        case 2:
            return "고급"
        default:
            return "잘못된값"
        }
    }
    
    // MARK: - @objc
    @objc
    private func touchUpModify() {
        isModified.toggle()
        listTableView.reloadSections(IndexSet(0...0), with: .fade)
        bottomView.selectButton.setTitle(isModified ? "수정한 영법 저장하기" : "영법 수정하기", for: .normal)
    }
}
