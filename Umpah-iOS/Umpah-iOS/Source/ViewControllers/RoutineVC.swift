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
        routineList = ["warm-up" : [RoutineItemData(stroke: "자유영", distance: "1225", time: 135),
                                    RoutineItemData(stroke: "자유영", distance: "1250", time: 235),
                                    RoutineItemData(stroke: "자유영", distance: "1275", time: 335)] ,
                       "main" : [RoutineItemData(stroke: "배형", distance: "1225", time: 130),
                                 RoutineItemData(stroke: "배형", distance: "1250", time: 131),
                                 RoutineItemData(stroke: "배형", distance: "1275", time: 132),
                                 RoutineItemData(stroke: "배형", distance: "1300", time: 133),
                                 RoutineItemData(stroke: "배형", distance: "1225", time: 134)],
                       "cool" : [RoutineItemData(stroke: "접형", distance: "1200", time: 100),
                                 RoutineItemData(stroke: "접형", distance: "1225", time: 200),
                                 RoutineItemData(stroke: "접형", distance: "1250", time: 300),
                                 RoutineItemData(stroke: "접형", distance: "1275", time: 400)]]
    }
    
    private func addActions(){
        bottomButton.addTarget(self, action: #selector(changeTableViewEditingMode), for: .touchUpInside)
    }
    
    @objc
    func changeTableViewEditingMode(){
        tableView.isEditing = tableView.isEditing ? false : true
        tableCellList.forEach{
            let item = $0 as! RoutineSetTVC
            let mode = item.tableView.isEditing ? false : true
            item.tableView.setEditing(mode, animated: true)
            if mode {
                item.changeLayoutAtEditingMode()
                item.routineCellList.forEach {
                    $0.changeLayoutAtEditingMode()
                }
            }else {
                item.turnToInitLayout()
                item.routineCellList.forEach {
                    $0.turnToInitLayout()
                }
            }
        }
    }

}

extension RoutineVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150 + routineList[tableSetTitleList[indexPath.row]]!.count * 44)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableSetTitleList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension RoutineVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.identifier) as? RoutineSetTVC else {
            return UITableViewCell()
        }
        
        let setTitle = tableSetTitleList[indexPath.row]
        
        cell.setRoutineContent(title: setTitle.uppercased() + " SET",
                               itemList: routineList[setTitle] ?? [])
        
        if tableCellList.count < 3 {
            tableCellList.append(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

}
