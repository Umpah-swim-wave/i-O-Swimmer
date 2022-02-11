//
//  MainVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit

import Charts
import RxCocoa
import RxSwift
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
    
    private func setupDummyRoutineOverViewList(){
        (0..<20).forEach {
            var data = RoutineOverviewData()
            data.level = Int.random(in: 0...2)
            data.totalDistance = 1000 + $0 * 150
            routineOverViewList.append(data)
        }
    }
    
    private func changeStateWhenTappedHeaderTab(){
        headerView.changeState = { [weak self] isRoutine in
            guard let self = self else { return }
            if isRoutine && self.currentMainViewState != .routine {
                self.cacheMainViewState = self.currentMainViewState
                self.currentMainViewState = .routine
            } else if !isRoutine {
                self.currentMainViewState = self.cacheMainViewState
            }
            self.cardView.currentState = self.currentMainViewState
            self.baseTableView.reloadData()
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
                    print("success")
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentMainViewState == .routine {
            return indexPath.row == 0 ? 184 : 170
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
            setupCardViewState(to: .normal)
        }
    }
}
