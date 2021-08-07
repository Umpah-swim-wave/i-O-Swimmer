//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

import SnapKit

enum CardViewState {
    case expanded
    case normal
}

class MainVC: UIViewController {
    // MARK: - Properties
    var cardView = UIView()
    var titleLabel = UILabel()
    var cardViewState : CardViewState = .normal
    var cardPanStartingTopConstant : CGFloat = 20.0
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
        view.addSubviews([cardView])
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        cardViewTopConstraint = cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        cardViewTopConstraint?.isActive = true
    }
    
    private func initUpperView() {
        view.backgroundColor = .init(red: 228/255, green: 237/255, blue: 255/255, alpha: 1.0)
    }
    
    private func initCardView() {
        cardView.backgroundColor = .white
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 32.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
    }
    
    private func initGestureView() {
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        view.addGestureRecognizer(dimmerTap)
        view.isUserInteractionEnabled = true
        
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
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            if atState == .expanded {
                cardViewTopConstraint?.constant = 30.0
            } else {
                cardViewTopConstraint?.constant = UIScreen.main.bounds.size.height * 0.42
            }
            
            cardPanStartingTopConstant = cardViewTopConstraint?.constant ?? 0
        }
        
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })

        showCard.startAnimation()
    }
    
    // MARK: - @objc
    @objc
    func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        showCard(atState: .normal)
    }
    
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
            if velocity.y > 1500.0 {
                showCard(atState: .normal)
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .expanded)
                    titleLabel.text = "My Progress"
                } else  {
                    showCard(atState: .normal)
                    titleLabel.text = "Total"
                }
            }
        default:
            break
        }
    }
}
