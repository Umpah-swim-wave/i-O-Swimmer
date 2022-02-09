//
//  MainCardVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/09.
//

import UIKit

class MainCardVC: BaseViewController {
    
    // MARK: - properties
    
    lazy var cardView = CardView(rootVC: self)
    var cardViewTopConstraint: NSLayoutConstraint?
    var cardPanStartingTopConstant : CGFloat = 20.0
    var cardPanMaxVelocity: CGFloat = 1500.0
    var currentState: CurrentState = .base
    var cacheState: CurrentState = .base
    var strokeState: Stroke = .none
    let storage = RecordStorage.shared
    lazy var rangeTexts: [String] = [serverDateformatter.string(from: Date()), ""]
    var dateformatter = DateFormatter().then {
        $0.dateFormat = "YY/MM/dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    var serverDateformatter = DateFormatter().then {
        $0.dateFormat = "YYYY-MM-dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    lazy var dateText: String = dateformatter.string(from: Date())

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - func
    
    func decideTopConstraint(of state: CardViewState) {
        switch state {
        case .normal:
            cardViewTopConstraint?.constant = UIScreen.main.hasNotch ? UIScreen.main.bounds.size.height * 0.8 : UIScreen.main.bounds.size.height * 0.87
        case .expanded:
            switch currentState {
            case .week:
                cardViewTopConstraint?.constant = UIScreen.main.bounds.size.height * 0.24
            case .month:
                cardViewTopConstraint?.constant = UIScreen.main.bounds.size.height * 0.38
            default:
                cardViewTopConstraint?.constant = 20.0
            }
        case .fail:
            break
        }
    }
    
    @objc
    func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
        
        if cardView.expandedView.isModified {
            panRecognizer.state = .failed
        }
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint?.constant ?? 0
        case .changed:
            if self.cardPanStartingTopConstant + translation.y > 20.0 {
                self.cardViewTopConstraint?.constant = self.cardPanStartingTopConstant + translation.y
            }
        case .ended:
            if velocity.y > cardPanMaxVelocity {
                cardView.cardViewState = .normal
                decideTopConstraint(of: .normal)
                return
            }
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = window?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.6 {
                    cardView.cardViewState = .expanded
                    decideTopConstraint(of: .expanded)
                } else  {
                    cardView.cardViewState = .normal
                    decideTopConstraint(of: .normal)
                }
            }
        default:
            cardView.cardViewState = .fail
        }
    }
}
