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
    
    // MARK: - Public Properties
    
    public var currentState: CurrentMainViewState = .base {
        didSet { showCard() }
    }
    
    public var cardViewState: CardViewState = .normal {
        didSet { showCard() }
    }
    
    public var dateText: String?
    
    // MARK: - Private Properties
    
    private var rootVC: MainCardVC?
    private var canScrollMore = true
    
    // MARK: - UI
    
    public lazy var expandedView = ExpandedStateView().then {
        $0.alpha = 0.0
    }
    public let normalView = NormalStateView()
    
    private let handleView = UIView().then {
        $0.backgroundColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        $0.layer.cornerRadius = 3
    }

    // MARK: - Initalizing
    init(rootVC: MainCardVC) {
        super.init(frame: .zero)
        self.rootVC = rootVC
        expandedView.root = rootVC
        
        showCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit BaseView instance")
    }
    
    // MARK: - Override Method
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

    // MARK: - Public Method
    
    public func showCard() {
        self.rootVC?.view.layoutIfNeeded()
        
        normalView.titleLabel.text = decideTitle(of: cardViewState)
        
        switch cardViewState {
        case .normal:
            normalView.fadeIn()
            expandedView.fadeOut()
            startAnimation()
        case .expanded:
            expandedView.state = currentState
            expandedView.titleLabel.text = applyExpandedTitle(of: currentState)
            expandedView.bottomView.isHidden = decideHiddenState(by: currentState)
            expandedView.listTableView.reloadData()
            
            normalView.fadeOut()
            expandedView.fadeIn()
            startAnimation()
        case .fail:
            if canScrollMore {
                canScrollMore = false
                
                let alert = makeRequestAlert(okAction: { _ in
                    self.expandedView.isModified = false
                    self.rootVC?.setupCardViewState(to: .normal)
                    self.expandedView.bottomView.selectButton.setTitle("영법 수정하기", for: .normal)
                    self.canScrollMore = true
                }, cancelAction: { _ in
                    self.canScrollMore = true
                })
                
                rootVC?.present(alert, animated: true, completion: nil)
            }
        }
        
        expandedView.changeTableViewLayout()
    }
    
    public func applyExpandedTitle(of state: CurrentMainViewState) -> String {
        switch state {
        case .base:
            return Date().getTimeString()
        case .routine:
            return "어푸가 추천하는 수영 루틴들"
        default:
            return dateText ?? "no date"
        }
    }
    
    public func decideTitle(of state: CardViewState) -> String {
        switch state {
        case .expanded:
            return ""
        default:
            switch currentState {
            case .week:
                return "요일별 기록 보기"
            case .month:
                return "주간별 기록 보기"
            case .routine:
                return "어푸가 추천하는 루틴 보기"
            default:
                return "랩스 기록 보기"
            }
        }
    }
}

// MARK: - Helper
extension CardView {
    private func startAnimation() {
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.rootVC?.view.layoutIfNeeded()
        })

        showCard.startAnimation()
    }
    
    private func decideHiddenState(by state: CurrentMainViewState) -> Bool {
        switch state {
        case .day, .base:
            return false
        default:
            return true
        }
    }
}
