//
//  CardView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/19.
//

import UIKit

import SnapKit
import Then

final class CardView: BaseView, Alertable {
    
    // MARK: - properties
    
    lazy var expandedView = ExpandedStateView().then {
        $0.alpha = 0.0
    }
    let normalView = NormalStateView()
    private let handleView = UIView().then {
        $0.backgroundColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        $0.layer.cornerRadius = 3
    }
    
    var currentState: CurrentMainViewState = .base {
        didSet { showCard() }
    }
    var cardViewState: CardViewState = .normal {
        didSet { showCard() }
    }
    var dateText: String?
    private var rootVC: MainCardVC
    private var canScrollMore = true
    private var dateformatter = DateFormatter().then {
        $0.dateFormat = "YY/MM/dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }

    // MARK: - init
    
    init(rootVC: MainCardVC) {
        self.rootVC = rootVC
        super.init(frame: .zero)
        expandedView.rootVC = rootVC
        showCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configUI() {
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 32.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: -2), 8)
    }
    
    override func render() {
        add(normalView) {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.safeAreaLayoutGuide)
            }
        }
        
        add(expandedView) {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        add(handleView) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.snp.top).offset(9)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(4)
                $0.width.equalTo(48)
            }
        }
    }

    // MARK: - func
    
    private func showCard() {
        self.rootVC.view.layoutIfNeeded()
        
        switch cardViewState {
        case .normal:
            normalView.fadeIn()
            expandedView.fadeOut()
            startAnimation()
        case .expanded:
            expandedView.currentMainViewState = currentState
            expandedView.titleLabel.text = applyExpandedTitle(of: currentState)
            expandedView.bottomView.isHidden = decideHiddenState(by: currentState)
            expandedView.listTableView.reloadData()
            
            normalView.fadeOut()
            expandedView.fadeIn()
            startAnimation()
        case .fail:
            if canScrollMore {
                canScrollMore = false
                presentAlertWhenBlockScroll()
            }
        }
        normalView.setupTitle(to: decideTitle(of: cardViewState)) 
        expandedView.changeTableViewLayout()
    }
    
    private func startAnimation() {
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.rootVC.view.layoutIfNeeded()
        })
        showCard.startAnimation()
    }
    
    private func presentAlertWhenBlockScroll() {
        let alert = makeRequestAlert(okAction: { _ in
            self.expandedView.isModified = false
            self.rootVC.setupCardViewState(to: .normal)
            self.expandedView.bottomView.selectButton.setTitle("영법 수정하기", for: .normal)
            self.canScrollMore = true
        }, cancelAction: { _ in
            self.canScrollMore = true
        })
        
        rootVC.present(alert, animated: true, completion: nil)
    }
    
    private func decideHiddenState(by state: CurrentMainViewState) -> Bool {
        return state.isHidden
    }
    
    private func applyExpandedTitle(of state: CurrentMainViewState) -> String {
        switch state {
        case .base:
            return dateformatter.string(from: Date())
        case .routine:
            return "어푸가 추천하는 수영 루틴들"
        default:
            return dateText ?? "no date"
        }
    }
    
    private func decideTitle(of state: CardViewState) -> String {
        switch state {
        case .expanded:
            return ""
        default:
            return currentState.title
        }
    }
}
