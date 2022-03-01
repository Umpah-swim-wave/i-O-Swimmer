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
    let routineFilterView = RoutineFilterView()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupModifyButton()
        setupDummyRoutineOverViewList()
        setupRoutineFilterActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
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
    
    // MARK: - func
    
    func changeTableViewLayout() {
        switch currentMainViewState {
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
    
    private func setupRoutineFilterLayout(){
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
    
    private func deleteRoutineFilterLayout(){
        routineFilterView.removeFromSuperview()
        backgroundColor = .clear
        listTableView.backgroundColor = .clear
    }
    
    private func setupRoutineFilterActions(){
        let presentinglevelAction = UIAction { _ in
            self.presentToModifyElementView(of: .level, before: self.routineFilterView.levelText)
        }
        let presentingStrokeAction = UIAction { _ in
            self.presentToModifyElementView(of: .exceptStorke, before: self.routineFilterView.exceptionStrokeText)
        }
        let changeOrderingDistanceAction = UIAction { _ in
            self.routineFilterView.changeDistanceButton()
        }
        
        routineFilterView.levelButton.addAction(presentinglevelAction, for: .touchUpInside)
        routineFilterView.exceptionButton.addAction(presentingStrokeAction, for: .touchUpInside)
        routineFilterView.distanceOrderButton.addAction(changeOrderingDistanceAction, for: .touchUpInside)
    }
    
    // TODO: - 서버통신 후 삭제할 더미 함수
    private func setupDummyRoutineOverViewList(){
        for _ in 0..<20 {
            var data = RoutineOverviewData()
            data.level = Int.random(in: 0...2)
            upuhRoutineOverViewList.append(data)
        }
        filteredOverViewList = upuhRoutineOverViewList
    }
    
    func presentToModifyElementView(of type: ModifyElementType, setTitle: String = "", index: Int = 0, before data: String = ""){
        let storyboard = UIStoryboard(name: "ModifyElement", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(identifier: ModifyElementVC.className) as? ModifyElementVC else {
            return
        }
        nextVC.sendFilterData = { [weak self] in
            self?.rootVC?.setupCardViewState(to: .expanded)
        }

        nextVC.setupModificationContent(of: type,
                                        setTitle: setTitle,
                                        index: index, before: data)
        
        nextVC.backgroundImage = self.rootVC?.view.asImage()
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = .crossDissolve
        self.rootVC?.present(nextVC, animated: true, completion: nil)
    }
    
    private func setupModifyButton() {
        bottomView.selectButton.addTarget(self, action: #selector(touchUpModify), for: .touchUpInside)
    }
    
    // MARK: - @objc
    @objc
    private func touchUpModify() {
        isModified.toggle()
        listTableView.reloadSections(IndexSet(0...0), with: .fade)
        bottomView.selectButton.setTitle(isModified ? "수정한 영법 저장하기" : "영법 수정하기", for: .normal)
    }
}
