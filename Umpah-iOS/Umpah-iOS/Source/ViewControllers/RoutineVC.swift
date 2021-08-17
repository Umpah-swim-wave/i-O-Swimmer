//
//  RoutineVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit
import SnapKit
import Then

class RoutineVC: UIViewController {

    static let identifier = "RoutineVC"
    private var routineList: [String : [RoutineItemData]] = [:]
    private let navigationView = UIView()
    private var tableView = UITableView()
    private var tableCellList : [UITableViewCell] = []
    private var tableSetTitleList : [String] = ["warm-up", "main", "cool"]
    private var bottomButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .blue
        $0.setTitle("어푸님만의 루틴 만들기", for: .normal)
        $0.titleLabel?.textColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        registerXib()
        initRoutineItem()
        setTableViewAttribute()
        view.backgroundColor = .systemGray6
        addActions()
    }

    private func setupConstraints(){
        view.addSubviews([navigationView,
                          tableView,
                          bottomButton])

        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(40)
        }
        bottomButton.bringSubviewToFront(tableView)
    }
    
    private func registerXib(){
        tableView.registerCustomXib(name: RoutineSetTVC.identifier)
    }
    
    private func setTableViewAttribute(){
        //tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func initRoutineItem(){
        routineList = ["warm-up" : [RoutineItemData(stroke: "자유영", distance: "1200", time: 135),
                                    RoutineItemData(stroke: "자유영", distance: "1200", time: 135),
                                    RoutineItemData(stroke: "자유영", distance: "1200", time: 135)] ,
                       "main" : [RoutineItemData(stroke: "배형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "배형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "배형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "배형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "배형", distance: "1200", time: 135)],
                       
                       "cool" : [RoutineItemData(stroke: "접형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "접형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "접형", distance: "1200", time: 135),
                                 RoutineItemData(stroke: "접형", distance: "1200", time: 135)]]
    }

}

extension RoutineVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return CGFloat(150 + routineList["warm-up"]!.count * 44)
        case 1 :
            return CGFloat(150 + routineList["main"]!.count * 44)
        default:
            return CGFloat(150 + routineList["cool"]!.count * 44)
        }
        
        return tableView.rowHeight
    }
    
}

extension RoutineVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.identifier) as? RoutineSetTVC else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.setRoutineContent(title: "WARM-UP SET", itemList: routineList["warm-up"] ?? [])
        case 1:
            cell.setRoutineContent(title: "MAIN SET", itemList: routineList["main"] ?? [])
        default:
            cell.setRoutineContent(title: "COOL-DOWN SET", itemList: routineList["cool"] ?? [])
        }
        
        return cell
        
    }
    
}
