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
    case base
    case expanded
    case normal
}

enum CurrentState {
    case day
    case week
    case month
    case routine
}

class MainVC: UIViewController {
    // MARK: - Lazy Properties
    lazy var mainTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 100
        $0.register(ChartTVC.self, forCellReuseIdentifier: ChartTVC.identifier)
        $0.register(DetailTVC.self, forCellReuseIdentifier: DetailTVC.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    // MARK: - Properties
    var cardView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    let topView = TopView()
    let headerView = HeaderView()
    let normalView = NormalStateView()
    let expandedView = ExpandedStateView()
    
    var currentState: CurrentState = .routine
    var cardViewState: CardViewState = .base
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
        showCard(atState: cardViewState)
    }
    
    // MARK: - Custom Methods
    private func setupLayout() {
        view.addSubviews([mainTableView, cardView])
        cardView.addSubviews([normalView, expandedView])
        
        mainTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
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
        view.backgroundColor = .init(red: 166/255, green: 226/255, blue: 226/255, alpha: 1.0)
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
        
        cardPanStartingTopConstant = decideTopConstraint(of: atState)
        normalView.titleLabel.text = decideTitle(of: atState)
        
        switch atState {
        case .base:
            cardViewState = .expanded
        case .normal:
            cardViewState = .normal
            
            normalView.fadeIn()
            expandedView.fadeOut()
            startAnimation()
        case .expanded:
            if cardViewState == .normal {
                expandedView.listTableView.reloadData()
            }
            cardViewState = .expanded
            expandedView.state = currentState
            
            expandedView.fadeIn()
            normalView.fadeOut()
            startAnimation()
        }
    }
    
    private func startAnimation() {
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
            if self.cardPanStartingTopConstant + translation.y > 20.0 {
                self.cardViewTopConstraint?.constant = self.cardPanStartingTopConstant + translation.y
            }
        case .ended:
            if velocity.y > cardPanMaxVelocity {
                showCard(atState: .normal)
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.6 {
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

// MARK: - Helper
extension MainVC {
    private func decideTopConstraint(of state: CardViewState) -> CGFloat {
        switch state {
        case .base:
            cardViewTopConstraint?.constant = UIScreen.main.hasNotch ? UIScreen.main.bounds.size.height * 0.8 : UIScreen.main.bounds.size.height * 0.87
        case .normal:
            cardViewTopConstraint?.constant = UIScreen.main.hasNotch ? UIScreen.main.bounds.size.height * 0.8 : UIScreen.main.bounds.size.height * 0.87
        case .expanded:
            cardViewTopConstraint?.constant = 20.0
        }
        
        guard let constant = cardViewTopConstraint?.constant else { return 0 }
        return constant
    }
    
    private func decideTitle(of state: CardViewState) -> String {
        switch state {
        case .expanded:
            return ""
        default:
            switch currentState {
            case .day:
                return "랩스 기록 보기"
            case .week:
                return "요일별 기록 보기"
            case .month:
                return "주간별 기록 보기"
            case .routine:
                return "어푸가 추천하는 루틴 보기"
            }
        }
    }
}

extension MainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
            cell.backgroundColor = .init(red: 223/255, green: 231/255, blue: 233/255, alpha: 1.0)
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTVC.identifier) as? ChartTVC else { return UITableViewCell() }
            cell.lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuint)
            cell.backgroundColor = .init(red: 223/255, green: 231/255, blue: 233/255, alpha: 1.0)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return topView
        default:
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 143
        case 1:
            return 50
        default:
            return 0
        }
    }
}
