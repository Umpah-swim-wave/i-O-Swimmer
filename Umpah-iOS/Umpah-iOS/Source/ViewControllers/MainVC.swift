//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import Charts

final class MainVC: BaseViewController {

    // MARK: - UI
    
    public lazy var baseTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(ChartTVC.self, forCellReuseIdentifier: ChartTVC.identifier)
        $0.register(DetailTVC.self, forCellReuseIdentifier: DetailTVC.identifier)
        $0.register(FilterTVC.self, forCellReuseIdentifier: FilterTVC.identifier)
        $0.register(StrokeTVC.self, forCellReuseIdentifier: StrokeTVC.identifier)
        $0.register(DateTVC.self, forCellReuseIdentifier: DateTVC.identifier)
        $0.register(RoutineTVC.self)
        $0.backgroundColor = .clear
        $0.estimatedRowHeight = 100
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    public lazy var cardView = CardView(rootVC: self)
    
    private let topView = TopView()
    private let headerView = HeaderView()
    private let statusBar = StatusBar()
    
    // MARK: - Properties
    
    private lazy var dateText: String = dateformatter.string(from: Date())
    private var cardViewTopConstraint: NSLayoutConstraint?
    private var cardPanStartingTopConstant : CGFloat = 20.0
    private var cardPanMaxVelocity: CGFloat = 1500.0
    private var currentState: CurrentState = .base
    private var cacheState: CurrentState = .base
    private var strokeState: Stroke = .none
    private var dateformatter = DateFormatter().then {
        $0.dateFormat = "YY/MM/dd"
        $0.locale = Locale.init(identifier: "ko-KR")
    }
    
    // MARK: - Routine data
    
    var routineOverViewList: [RoutineOverviewData] = []
    let swimmingViewModel = SwimmingDataViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addClosureToChangeState()
        authorizeHealthKit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        decideTopConstraint(of: .normal)
    }
    
    // MARK: - Override Method
    
    override func render() {
        view.add(statusBar) {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(UIApplication.statusBarHeight)
            }
        }
        
        view.add(baseTableView) {
            $0.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        view.add(cardView) {
            $0.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
            self.cardViewTopConstraint = $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
            self.cardViewTopConstraint?.isActive = true
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
              let bottomPadding = window?.safeAreaInsets.bottom {
                self.cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
            }
        }
    }
    
    override func configUI() {
        super.configUI()
        initGestureView()
        initRoutineOverViewList()
    }
}

// MARK: - Custom Methods
extension MainVC {
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
            self.cardView.currentState = self.currentState
            self.baseTableView.reloadData()
        }
    }
}

// MARK: - Animation
extension MainVC {
    // MARK: - @objc
    
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

// MARK: - Helper
extension MainVC {
    private func decideTopConstraint(of state: CardViewState) {
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
        if cardView.cardViewState == .expanded {
            cardView.cardViewState = .normal
        }
    }
}

// MARK: - SelectedRange Delegate
extension MainVC: SelectedRangeDelegate {
    func didClickedRangeButton() {
        cardView.cardViewState = .normal
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedRangeVC") as? SelectedRangeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.dayData = { year, month, day in
            print("dayData : \(year) \(month) \(day)")
            let transYear = year[year.index(year.startIndex, offsetBy: 2)..<year.endIndex]
            let transMonth = (month.count == 1) ? "0\(month)" : month
            let transDay = (day.count == 1) ? "0\(day)" : day
            self.dateText = "\(transYear)/\(transMonth)/\(transDay)"
            self.cardView.dateText = self.dateText
            self.currentState = (self.dateText == self.dateformatter.string(from: Date())) ? .base : .day
            self.strokeState = .none
            self.baseTableView.reloadSections(IndexSet(1...1), with: .fade)
            self.cardView.currentState = self.currentState
        }
        vc.weekData = { week in
            print("weekData : \(week)")
            self.dateText = week
            self.cardView.dateText = self.dateText
            self.currentState = .week
            self.strokeState = .none
            self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
            self.cardView.currentState = self.currentState
        }
        vc.monthData = { year, month in
            print("monthData : \(year) \(month)")
            let transMonth = (month.count == 1) ? "0\(month)" : month
            self.dateText = "\(year)/\(transMonth)"
            self.cardView.dateText = self.dateText
            self.currentState = .month
            self.strokeState = .none
            self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
            self.cardView.currentState = self.currentState
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func didClickedStrokeButton(indexPath: Int = 0) {
        cardView.cardViewState = .normal
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.strokeData = { style in
            print(style)
            self.strokeState = style
            self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
        }
        
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - HealthKit
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
