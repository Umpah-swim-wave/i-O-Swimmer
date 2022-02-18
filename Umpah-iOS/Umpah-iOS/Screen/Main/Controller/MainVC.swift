//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

import SnapKit
import Then

final class MainVC: MainTableVC {

    // MARK: - properties
    
    private let swimmingViewModel = SwimmingDataViewModel()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeStateWhenTappedHeaderTab()
        authorizeHealthKit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCardViewState(to: .normal)
    }
    
    override func render() {
        view.addSubviews([statusBar, baseTableView, cardView])
        
        statusBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(StatusBarDelegate.shared.height)
        }
        
        baseTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        cardViewTopConstraint = cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        cardViewTopConstraint?.isActive = true
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let safeAreaHeight = window.safeAreaLayoutGuide.layoutFrame.size.height
            let bottomPadding = window.safeAreaInsets.bottom
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
    }
    
    override func configUI() {
        super.configUI()
        baseTableView.delegate = self
        setupDummyRoutineOverViewList()
    }
    
    // MARK: - func
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKitAtSwimming { [weak self] authorized, error in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                }
                return
            }
            print("HealthKit Successfully Authorized.")
            self?.postRecordData()
            self?.swimmingViewModel.initSwimmingData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self?.swimmingViewModel.refineSwimmingDataForServer()
                print("refineSwimmingDataForServer.")
            }
        }
    }
    
    private func postRecordData(){
        swimmingViewModel
            .swimmingSubject
            .bind(onNext: { [weak self] workoutList in
                guard let self = self else { return }
                print("workoutList.count------------\(workoutList.count)---------------")
                workoutList.forEach{
                    print("\($0.display())")
                    print("count = \($0.recordLabsList.count)")
                }
                print("----------------------------")
                self.storage.dispatchRecord(workoutList: workoutList) {
                    print("success")                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDummyRoutineOverViewList(){
        (0..<20).forEach {
            var data = RoutineOverviewData()
            data.level = Int.random(in: 0...2)
            data.totalDistance = 1000 + $0 * 150
            routineOverViewList.append(data)
        }
    }
    
    private func changeStateWhenTappedHeaderTab(){
        headerView.pressedTabIsRecord = { [weak self] isRecord in
            guard let self = self else { return }
            self.setupCardViewState(to: .normal)
            
            if !isRecord && self.currentMainViewState != .routine {
                self.cacheMainViewState = self.currentMainViewState
                self.currentMainViewState = .routine
            } else if isRecord {
                self.currentMainViewState = self.cacheMainViewState
            }
            self.cardView.currentState = self.currentMainViewState
            self.baseTableView.reloadData()
        }
    }
    
    private func changeTopAreaBackgroundColor(to headerColor: UIColor,
                                              with statusBarColor: UIColor? = nil) {
        headerView.backgroundColor = headerColor
        if let statusBarColor = statusBarColor {
            statusBar.backgroundColor = statusBarColor
        }
    }
    
    private func changeTopViewConfiguration(alpha: CGFloat,
                                            transform: CGAffineTransform? = nil) {
        if let transform = transform {
            topView.titleLabel.transform = transform
            topView.nameLabel.transform = transform
        }
        topView.titleLabel.alpha = alpha
        topView.nameLabel.alpha = alpha
    }
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentMainViewState {
        case .routine:
            return indexPath.row == .zero ? 184 : 170
        default:
            guard let dayBaseRowType = DayBaseRowType(rawValue: indexPath.row) else { return 0 }
            switch dayBaseRowType {
            case .footer:
                return 105
            default:
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = TotalSection(rawValue: section) else { return UIView() }
        switch sectionType {
        case .topHeader:
            return topView
        case .content:
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = TotalSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .topHeader:
            return 143
        case .content:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentMainViewState == .routine {
            let storyboard = UIStoryboard(name: "Routine", bundle: nil)
            guard let routineVC = storyboard.instantiateViewController(withIdentifier: RoutineVC.className) as? RoutineVC else {return}
            routineVC.modalPresentationStyle = .overFullScreen
            present(routineVC, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let touchToSafeAreaTop = offsetY >= 188
        let scrollingThroughTableView = (offsetY < 188) && ((offsetY / 188) > 0.3)
        let scrollingThroughTableViewForTopView = offsetY > 0

        if touchToSafeAreaTop {
            changeTopAreaBackgroundColor(to: .upuhSkyBlue,
                                         with: .upuhSkyBlue)
        } else if scrollingThroughTableView {
            changeTopAreaBackgroundColor(to: .upuhSkyBlue.withAlphaComponent(offsetY / 188),
                                         with: .clear)
        } else {
            changeTopAreaBackgroundColor(to: .upuhSkyBlue.withAlphaComponent(0.3))
        }
        
        if touchToSafeAreaTop {
            changeTopViewConfiguration(alpha: 0)
        } else if scrollingThroughTableViewForTopView {
            changeTopViewConfiguration(alpha: 1 - (offsetY / 95),
                                       transform: CGAffineTransform(translationX: -offsetY/140, y: 0))
        } else {
            changeTopViewConfiguration(alpha: 1, transform: .identity)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if cardView.cardViewState == .expanded {
            setupCardViewState(to: .normal)
        }
    }
}
