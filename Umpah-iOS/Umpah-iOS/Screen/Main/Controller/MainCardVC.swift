//
//  MainCardVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/09.
//

import UIKit

import Then

class MainCardVC: BaseViewController {
    
    private enum Size {
        static let defaultTopConstant = 20.0
    }
    
    // MARK: - properties
    
    lazy var cardView = CardView(rootVC: self)
    var cardViewTopConstraint: NSLayoutConstraint?
    var cardViewMaxVelocity: CGFloat = 1500.0
    var cardViewTopConstant : CGFloat = 20.0
    
    var currentMainViewState: CurrentMainViewState = .base
    var cacheMainViewState: CurrentMainViewState = .base
    var strokeState: Stroke = .none
    
    lazy var selectedDates: [String] = [dateformatterForServer.string(from: Date()), ""]
    lazy var dateText: String = dateformatterForScreen.string(from: Date())
    var dateformatterForServer = DateFormatter().then {
        $0.dateFormat = "YYYY-MM-dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    var dateformatterForScreen = DateFormatter().then {
        $0.dateFormat = "YY/MM/dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    let storage = RecordStorage.shared
    
    // MARK: - override
    
    override func configUI() {
        super.configUI()
        setupPanGestureRecognizer()
    }
    
    // MARK: - func
    
    func applyCardViewTopConstraint(with state: CardViewState) {
        let screenHeight = UIScreen.main.bounds.size.height
        var topConstraint: CGFloat = 0
        
        switch state {
        case .normal:
            topConstraint = UIScreen.main.hasNotch ? screenHeight * 0.8 : screenHeight * 0.87
        case .expanded:
            switch currentMainViewState {
            case .week:
                topConstraint = screenHeight * 0.24
            case .month:
                topConstraint = screenHeight * 0.38
            default:
                topConstraint = Size.defaultTopConstant
            }
        default:
            break
        }
        
        cardViewTopConstraint?.constant = topConstraint
    }
    
    private func setupPanGestureRecognizer() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(cardViewScrolled(with:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    @objc
    private func cardViewScrolled(with panRecognizer: UIPanGestureRecognizer) {
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
        let isBlockedScroll = cardView.expandedView.isModified
        
        if isBlockedScroll {
            panRecognizer.state = .failed
        }
        
        switch panRecognizer.state {
        case .began:
            cardViewTopConstant = cardViewTopConstraint?.constant ?? 0
        case .changed:
            let isScrolling = cardViewTopConstant + translation.y > Size.defaultTopConstant
            if isScrolling {
                cardViewTopConstraint?.constant = self.cardViewTopConstant + translation.y
            }
        case .ended:
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                scrolledToFinish(with: window)
            }
            scrolledToFinish(with: velocity)
        default:
            cardView.cardViewState = .fail
        }
    }
    
    private func scrolledToFinish(with velocity: CGPoint) {
        let scrolledToFinish = velocity.y > cardViewMaxVelocity
        if scrolledToFinish {
            cardView.cardViewState = .normal
            applyCardViewTopConstraint(with: .normal)
        }
    }
    
    private func scrolledToFinish(with window: UIWindow) {
        let safeAreaHeight = window.safeAreaLayoutGuide.layoutFrame.size.height
        let bottomPadding = window.safeAreaInsets.bottom
        let isOverTheMiddleOfHeight = cardViewTopConstraint?.constant ?? 0 >= (safeAreaHeight + bottomPadding) * 0.6
        
        cardView.cardViewState = isOverTheMiddleOfHeight ? .normal : .expanded
        applyCardViewTopConstraint(with: isOverTheMiddleOfHeight ? .normal : .expanded)
    }
}
