//
//  RoutineSetTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/06.
//

import UIKit
import SnapKit
import Then
import Charts

protocol RoutineCellDelegate{
    func routineItemCellForAdding(cell: RoutineSetTVC, index: Int)
    func routineItemCellForDeleting(cell: RoutineSetTVC, index: Int)
}

class RoutineSetTVC: UITableViewCell {
    static let identifier = "RoutineSetTVC"
    public var viewModel: RoutineViewModel?
    private var routineListInSet : [RoutineItemData] = []
    public var routineItemCellList: [RoutineItemTVC] = []
    public var routineAddAction: (() -> ())?
    public var cellDelegate : RoutineCellDelegate?
    public var routineSetTitle = ""
    public var titleLabel = UILabel().then{
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .black
    }
    private var tableBackgroundView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private var strokeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "영법"
    }
    
    private var distanceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "거리(m)"
    }
    
    private var timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.text = "시간"
    }
    
    public var tableView = UITableView().then{
        $0.registerCustomXib(name: RoutineItemTVC.identifier)
    }
    
    public var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
        
    public var isEditingMode: Bool = false {
        didSet{
            print("routine set에서 바뀔꺼임 \(isEditingMode)")
            if isEditingMode{
                changeLayoutAtEditingMode()
                tableView.tableFooterView = setTableViewFooter()
            }else{
                turnToInitLayout()
                tableView.tableFooterView = nil
            }
            routineItemCellList.forEach{
                print("item에 넣어줄 editing mode \(isEditingMode)")
                $0.isEditingMode = isEditingMode
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setTableViewAttribute()
        initRoutineItemCells()
        setupLayout()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func setTableViewAttribute(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    public func setRoutineContent(title: String, viewModel: RoutineViewModel){
        routineSetTitle = title
        titleLabel.text = routineSetTitle.uppercased() + " SET"
        self.viewModel = viewModel
        routineListInSet = viewModel.routineStorage.routineList[title] ?? []
        initRoutineItemCells()
    }
    
    private func initRoutineItemCells(){
        var list: [RoutineItemTVC] = []
        routineListInSet.forEach{
            print("routine = \($0)")
            let cell = self.getRoutineItemCell(item: $0)
            list.append(cell)
        }
        routineItemCellList = list
    }

    private func getRoutineItemCell(item: RoutineItemData) -> RoutineItemTVC {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineItemTVC.identifier) as? RoutineItemTVC else{
            return RoutineItemTVC()
        }
        cell.setRoutineItem(item: item, isEditing: isEditingMode)
        //cell.isEditingMode = isEditingMode
        return cell
    }
}

extension RoutineSetTVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == routineItemCellList.count ? 68 : 44
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel?.routineStorage.swapRoutineItems(setTitle: routineSetTitle,
                                                   sourceIndex: sourceIndexPath.row,
                                                   destinationIndex: destinationIndexPath.row)
        routineItemCellList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel?.routineStorage.delete(setTitle: routineSetTitle, index: indexPath.row)
            routineItemCellList.remove(at: indexPath.row)
            cellDelegate?.routineItemCellForDeleting(cell: self, index: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension RoutineSetTVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineItemCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return routineItemCellList[indexPath.row]

    }
    
    public func setTableViewFooter() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 68))
        
        let titleButton = UIButton().then{
            $0.setTitle("영법 추가하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12)
            $0.setTitleColor(.gray, for: .normal)
            $0.addTarget(self, action: #selector(addInitRoutineItem), for: .touchUpInside)
        }
        
        let titleUnderline = UIView().then{
            $0.backgroundColor = .gray
        }
        
        view.addSubviews([titleButton,
                          titleUnderline])
        titleButton.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        titleUnderline.snp.makeConstraints{
            $0.top.equalTo(titleButton.snp.bottom).offset(-3)
            $0.centerX.equalTo(titleButton.snp.centerX)
            $0.width.equalTo(titleButton.snp.width)
            $0.height.equalTo(1)
        }
        return view
    }
    
    @objc func addInitRoutineItem(){
        print("addInitRoutineItem 눌림")
        viewModel?.routineStorage.createRoutine(setTitle: routineSetTitle)
        addRoutineItemCell()
        print("cellDelegate = \(cellDelegate)")
        cellDelegate?.routineItemCellForAdding(cell: self, index: routineItemCellList.count - 1)
        tableView.reloadData()
    }
    
    private func addRoutineItemCell(){
        let cell = getRoutineItemCell(item: RoutineItemData())
        routineItemCellList.append(cell)
        routineItemCellList.last?.isEditingMode = true
    }
}

//MARK: UI
extension RoutineSetTVC {
    private func setupLayout(){
        addSubviews([titleLabel,
                     tableBackgroundView])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tableBackgroundView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        
        tableBackgroundView.addSubviews([strokeLabel,
                                         distanceLabel,
                                         timeLabel,
                                         tableView])
        
        strokeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
        }
                
        distanceLabel.snp.makeConstraints{
            $0.centerY.equalTo(strokeLabel.snp.centerY)
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-51)
        }
        
        timeLabel.snp.makeConstraints{
            $0.centerY.equalTo(strokeLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(47)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(strokeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    public func changeLayoutAtEditingMode(){
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(46)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-63)
        }
    }
    
    public func turnToInitLayout(){
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(24)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-47)
        }
    }
}

