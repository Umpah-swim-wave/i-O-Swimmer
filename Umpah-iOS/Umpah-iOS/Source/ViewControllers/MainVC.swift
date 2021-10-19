//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

import Charts

final class MainVC: BaseViewController {
    
    // MARK: - Lazy UI
    lazy var mainTableView = UITableView(frame: .zero, style: .plain).then {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 100
        $0.register(ChartTVC.self, forCellReuseIdentifier: ChartTVC.identifier)
        $0.register(DetailTVC.self, forCellReuseIdentifier: DetailTVC.identifier)
        $0.register(FilterTVC.self, forCellReuseIdentifier: FilterTVC.identifier)
        $0.register(StrokeTVC.self, forCellReuseIdentifier: StrokeTVC.identifier)
        $0.register(DateTVC.self, forCellReuseIdentifier: DateTVC.identifier)
        $0.register(RoutineTVC.self)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    lazy var dateText: String = dateformatter.string(from: Date())
    
    // MARK: - Properties
    var cardView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 32.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: -2), 8)
    }
    
    lazy var expandedView = ExpandedStateView(root: self)
    let topView = TopView()
    let headerView = HeaderView()
    let statusBar = StatusBar()
    let normalView = NormalStateView()
    
    var currentState: CurrentState = .base
    var cardViewState: CardViewState = .base
    var cacheState: CurrentState = .base
    var strokeState: Stroke = .none
    var cardPanStartingTopConstant : CGFloat = 20.0
    var cardPanMaxVelocity: CGFloat = 1500.0
    var cardViewTopConstraint: NSLayoutConstraint?
    var dateformatter = DateFormatter().then {
        $0.dateFormat = "YY/MM/dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    var canScrollMore = true
    
    //MARK: Routine data
    var routineOverViewList: [RoutineOverviewData] = []
    let swimmingViewModel = SwimmingDataViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        initUpperView()
        initCardView()
        initGestureView()
        initRoutineOverViewList()
        addClosureToChangeState()
        authorizeHealthKit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCard(atState: cardViewState)
    }
    
    // MARK: - Custom Methods
    func setupLayout() {
        view.addSubviews([statusBar, mainTableView, cardView])
        cardView.addSubviews([normalView, expandedView])
        
        statusBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight)
        }
        
        mainTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
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
        view.backgroundColor = .upuhBlue
    }
    
    private func initCardView() {
        expandedView.alpha = 0.0
        
        let handleView = UIView()
        handleView.backgroundColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        handleView.layer.cornerRadius = 3
        cardView.addSubview(handleView)
        handleView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(48)
        }
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = window?.safeAreaInsets.bottom {
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
    }
    
    private func initGestureView() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    private func initRoutineOverViewList(){
        for i in 0..<20 {
            var data = RoutineOverviewData()
            data.level = Int.random(in: 0...2)
            data.totalDistance = 1000 + i * 150
            routineOverViewList.append(data)
        }
    }
    
    private func addClosureToChangeState(){
        headerView.changeState = { isRecord in
            //어떻게 하면 좋을지,,
            if !isRecord{
                self.cacheState = self.currentState
                self.currentState = .routine
            }else{
                self.currentState = self.cacheState
            }
            self.normalView.titleLabel.text = self.decideTitle(of: .normal)
            self.mainTableView.reloadData()
        }
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
            cardViewState = .expanded
            expandedView.state = currentState
            expandedView.titleLabel.text = applyExpandedTitle(of: currentState)
            expandedView.bottomView.isHidden = decideHiddenState(by: currentState)
            expandedView.listTableView.reloadData()
            
            expandedView.fadeIn()
            normalView.fadeOut()
            startAnimation()
        case .fail:
            if canScrollMore {
                canScrollMore = false
                cardViewState = .fail
                
                makeRequestAlert(okAction: { _ in
                    self.expandedView.isModified = false
                    self.showCard(atState: .normal)
                    self.expandedView.bottomView.selectButton.setTitle("영법 수정하기", for: .normal)
                    self.canScrollMore = true
                }, cancelAction: { _ in self.canScrollMore = true })
            }
        }
        
        expandedView.changeTableViewLayout()
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
        
        if expandedView.isModified {
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
                showCard(atState: .normal)
                return
            }
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = window?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? 0 < (safeAreaHeight + bottomPadding) * 0.6 {
                    showCard(atState: .expanded)
                } else  {
                    showCard(atState: .normal)
                }
            }
        default:
            showCard(atState: .fail)
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
        
        guard let constant = cardViewTopConstraint?.constant else { return 0 }
        return constant
    }
    
    private func decideTitle(of state: CardViewState) -> String {
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
    
    private func applyExpandedTitle(of state: CurrentState) -> String {
        switch state {
        case .base:
            return dateformatter.string(from: Date())
        case .routine:
            return "어푸가 추천하는 수영 루틴들"
        default:
            return dateText
        }
    }
    
    private func decideHiddenState(by state: CurrentState) -> Bool {
        switch state {
        case .day, .base:
            return false
        default:
            return true
        }
    }
}

// MARK: - UITableViewDataSource
extension MainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if currentState != .routine {
                return 5
            } else {
                return routineOverViewList.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentState {
        case .day,
             .base:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.identifier) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.state = currentState
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.identifier) as? DateTVC else { return UITableViewCell() }
                cell.dateLabel.text = dateText
                cell.dateLabel.addCharacterSpacing(kernValue: 2)
                cell.dateLabel.font = .nexaBold(ofSize: 16)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
                cell.titleLabel.text = "OVERVIEW"
                cell.titleLabel.addCharacterSpacing(kernValue: 2)
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StrokeTVC.identifier) as? StrokeTVC else { return UITableViewCell() }
                cell.titleLabel.text = "TOTAL"
                cell.titleLabel.addCharacterSpacing(kernValue: 2)
                return cell
            default:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .week,
             .month:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.identifier) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.state = currentState
                cell.stroke = strokeState
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.identifier) as? DateTVC else { return UITableViewCell() }
                cell.dateLabel.text = dateText
                cell.dateLabel.addCharacterSpacing(kernValue: 2)
                if dateText == "이번주" || dateText == "지난주" {
                    cell.dateLabel.font = .IBMPlexSansSemiBold(ofSize: 16)
                } else {
                    cell.dateLabel.font = .nexaBold(ofSize: 16)
                }
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTVC.identifier) as? ChartTVC else { return UITableViewCell() }
                cell.combineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
                
                if currentState == .week {
                    cell.titleLabel.text = "WEEKLY RECORD"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                } else {
                    cell.titleLabel.text = "MONTHLY RECORD"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                }
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
                
                if currentState == .week {
                    cell.titleLabel.text = "WEEKLY OVERVIEW"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                } else {
                    cell.titleLabel.text = "MONTHLY OVERVIEW"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                }
                
                return cell
            default:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .routine:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVC.identifier) as? RoutineTVC else { return UITableViewCell()}
            cell.setContentData(overview: routineOverViewList[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentState == .routine {
            return indexPath.row == 0 ? 184 : 168
        }else {
            switch indexPath.row {
            case 4:
                return 105
            default:
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return topView
        case 1:
            return headerView
        default:
            return UIView()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y

        if y >= 188 {
            headerView.backgroundColor = .upuhSkyBlue
            statusBar.backgroundColor = .upuhSkyBlue
        } else if y < 188 && (y / 188) > 0.3 {
            headerView.backgroundColor = .upuhSkyBlue.withAlphaComponent(y / 188)
            statusBar.backgroundColor = .clear
        } else {
            headerView.backgroundColor = .upuhSkyBlue.withAlphaComponent(0.3)
        }
        
        if y >= 188 {
            topView.titleLabel.alpha = 0
            topView.nameLabel.alpha = 0
        } else if y > 0 {
            topView.titleLabel.transform = CGAffineTransform(translationX: -y/140, y: 0)
            topView.titleLabel.alpha = 1 - (y / 95)
            topView.nameLabel.transform = CGAffineTransform(translationX: -y/140, y: 0)
            topView.nameLabel.alpha = 1 - (y / 95)

        } else {
            topView.titleLabel.transform = .identity
            topView.titleLabel.alpha = 1
            topView.nameLabel.transform = .identity
            topView.nameLabel.alpha = 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if cardViewState == .expanded {
            showCard(atState: .normal)
        }
    }
}

// MARK: - SelectedRange Delegate
extension MainVC: SelectedRangeDelegate {
    func didClickedRangeButton() {
        showCard()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedRangeVC") as? SelectedRangeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.dayData = { year, month, day in
            print("dayData : \(year) \(month) \(day)")
            let transYear = year[year.index(year.startIndex, offsetBy: 2)..<year.endIndex]
            let transMonth = (month.count == 1) ? "0\(month)" : month
            let transDay = (day.count == 1) ? "0\(day)" : day
            self.dateText = "\(transYear)/\(transMonth)/\(transDay)"
            self.currentState = (self.dateText == self.dateformatter.string(from: Date())) ? .base : .day
            self.strokeState = .none
            self.mainTableView.reloadSections(IndexSet(1...1), with: .fade)
            self.normalView.titleLabel.text = self.decideTitle(of: .normal)
        }
        vc.weekData = { week in
            print("weekData : \(week)")
            self.dateText = week
            self.currentState = .week
            self.strokeState = .none
            self.mainTableView.reloadSections(IndexSet(1...1), with: .automatic)
            self.normalView.titleLabel.text = self.decideTitle(of: .normal)
        }
        vc.monthData = { year, month in
            print("monthData : \(year) \(month)")
            let transMonth = (month.count == 1) ? "0\(month)" : month
            self.dateText = "\(year)/\(transMonth)"
            self.currentState = .month
            self.strokeState = .none
            self.mainTableView.reloadSections(IndexSet(1...1), with: .automatic)
            self.normalView.titleLabel.text = self.decideTitle(of: .normal)
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func didClickedStrokeButton(indexPath: Int = 0) {
        showCard()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.strokeData = { style in
            print(style)
            self.strokeState = style
            self.mainTableView.reloadSections(IndexSet(1...1), with: .automatic)
        }
        
        present(vc, animated: true, completion: nil)
    }
}

//MARK: HealthKit
extension MainVC {
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKitAtSwimming { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
            self.swimmingViewModel.initSwimmingData()
        }
    }
}
