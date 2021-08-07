//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

import Then
import SnapKit
import Charts

enum CardViewState {
    case expanded
    case normal
}

class MainVC: UIViewController {
    // MARK: - Properties
    var cardView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    var routineView = RectangularDashedView().then {
        $0.backgroundColor = .lightGray
        $0.cornerRadius = 16
        $0.dashWidth = 2
        $0.dashColor = .black
        $0.betweenDashesSpace = 8
        $0.dashLength = 8
    }
    var titleLabel = UILabel().then {
        $0.text = "어푸님!\n수영하기 좋은 날이에요!"
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 24, weight: .medium)
    }
    let normalView = NormalStateView()
    let expandedView = ExpandedStateView()
    
    var cardViewState : CardViewState = .expanded
    var cardPanStartingTopConstant : CGFloat = 20.0
    var cardPanMaxVelocity: CGFloat = 1500.0
    var cardViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        initUpperView()
        initCardView()
        initGestureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCard()
    }
    
    // MARK: - Custom Methods
    private func setupLayout() {
        view.addSubviews([titleLabel, routineView, cardView])
        cardView.addSubviews([normalView, expandedView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.equalToSuperview().inset(24)
        }
        
        routineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        cardViewTopConstraint = cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        cardViewTopConstraint?.isActive = true
        
        normalView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        expandedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func initUpperView() {
        view.backgroundColor = .init(red: 228/255, green: 237/255, blue: 255/255, alpha: 1.0)
    }
    
    private func initCardView() {
        expandedView.alpha = 0.0
        
        let handleView = UIView()
        handleView.backgroundColor = .lightGray
        handleView.layer.cornerRadius = 3
        cardView.addSubview(handleView)
        handleView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(48)
        }
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
    }
    
    private func initGestureView() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
}

// MARK: - Animation
extension MainVC {
    private func showCard(atState: CardViewState = .normal) {
        self.view.layoutIfNeeded()
        
        if atState == .expanded {
            cardViewTopConstraint?.constant = 30.0
            expandedView.lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuint)
            expandedView.fadeIn()
            normalView.fadeOut()
            cardViewState = .expanded
        } else {
            cardViewTopConstraint?.constant = UIScreen.main.bounds.size.height * 0.42
            normalView.fadeIn()
            expandedView.fadeOut()
            
            if cardViewState == .expanded {
                normalView.lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuint)
            }
            cardViewState = .normal
        }
        
        cardPanStartingTopConstant = cardViewTopConstraint?.constant ?? 0
        
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })

        showCard.startAnimation()
    }
    
    // MARK: - @objc
    @objc
    func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint?.constant ?? 0
        case .changed:
            if self.cardPanStartingTopConstant + translation.y > 30.0 {
                self.cardViewTopConstraint?.constant = self.cardPanStartingTopConstant + translation.y
            }
        case .ended:
            if velocity.y > cardPanMaxVelocity {
                showCard(atState: .normal)
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .expanded)
                } else  {
                    showCard(atState: .normal)
                }
            }
        default:
            break
        }
    }
}
