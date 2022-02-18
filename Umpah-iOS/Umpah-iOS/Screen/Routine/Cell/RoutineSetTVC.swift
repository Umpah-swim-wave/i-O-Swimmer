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
    func routineItenCellForSwapping(cell: RoutineSetTVC, source: Int, destination: Int)
}

class RoutineSetTVC: UITableViewCell {
    public var viewModel: RoutineViewModel?
    private var routineListInSet : [RoutineItemData] = []
    public var routineItemCellList: [RoutineItemTVC] = []
    public var routineAddAction: (() -> ())?
    public var cellDelegate : RoutineCellDelegate?
    public var routineSetTitle = ""
    public var titleLabel = UILabel().then{
        $0.font = .nexaBold(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    private var tableBackgroundView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private var strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhGreen
        $0.text = "영법"
    }
    
    private var distanceLabel = UILabel().then {
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhGreen
        $0.text = "거리(m)"
    }
    
    private var timeLabel = UILabel().then {
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhGreen
        $0.text = "시간"
    }
    
    public var reorderImageView = UIImageView().then {
        $0.image = UIImage(named: "reorderIconWide")
        $0.isHidden = true
    }
    
    public var tableView = UITableView().then{
        $0.registerCustomXib(name: RoutineItemTVC.className)
    }
    
    private var reorderControlImageView: UIImageView? {
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
        updateReorderImageView()
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
        titleLabel.addCharacterSpacing(kernValue: 2.0)
        self.viewModel = viewModel
        routineListInSet = viewModel.routineStorage.routineList[title] ?? []
        initRoutineItemCells()
    }
    
    private func initRoutineItemCells(){
        var list: [RoutineItemTVC] = []
        for index in 0..<routineListInSet.count{
            let cell = self.getRoutineItemCell(item: routineListInSet[index])
            cell.selectDistance = { newDistance in
                self.viewModel?.routineStorage.update(distance: newDistance,
                                                      setTitle: self.routineSetTitle,
                                                      index: index)
            }
            
            cell.selectTime = { newTime in
                self.viewModel?.routineStorage.update(time: newTime,
                                                      setTitle: self.routineSetTitle,
                                                      index: index)
            }
            list.append(cell)
        }
        routineItemCellList = list
    }

    private func getRoutineItemCell(item: RoutineItemData) -> RoutineItemTVC {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineItemTVC.className) as? RoutineItemTVC else{
            return RoutineItemTVC()
        }
        cell.setRoutineItem(item: item, isEditing: isEditingMode)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel?.routineStorage.swapRoutineItems(setTitle: routineSetTitle,
                                                   sourceIndex: sourceIndexPath.row,
                                                   destinationIndex: destinationIndexPath.row)
        routineItemCellList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        cellDelegate?.routineItenCellForSwapping(cell: self,
                                                 source: sourceIndexPath.row,
                                                 destination: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("indexPath = \(indexPath), editingStyle = \(editingStyle)")
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
                                        width: tableView.frame.width,
                                        height: 68))

        let titleButton = UIButton().then{
            $0.setTitle("영법 추가하기", for: .normal)
            $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 12)
            $0.setTitleColor(.upuhGreen, for: .normal)
            $0.addTarget(self, action: #selector(addInitRoutineItem), for: .touchUpInside)
        }
        
        let titleUnderline = UIView().then{
            $0.backgroundColor = .upuhGreen
        }
        
        view.addSubviews([titleButton,
                          titleUnderline])
        let titleButtonX = (view.frame.width - titleButton.frame.width) / 2.0
        print("titleButtonX = \(titleButtonX)")
        print("view.midX = \(view.frame.midX)")
        print("view.CenterX = \(view.snp.centerX)")
        titleButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(6)
        }
        
        titleUnderline.snp.makeConstraints{
            $0.top.equalTo(titleButton.snp.bottom).offset(-9)
            $0.centerX.equalTo(titleButton.snp.centerX)
            $0.width.equalTo(titleButton.snp.width)
            $0.height.equalTo(1.5)
        }
        return view
    }
    
    @objc func addInitRoutineItem(){
        viewModel?.routineStorage.createRoutine(setTitle: routineSetTitle)
        addRoutineItemCell()
        cellDelegate?.routineItemCellForAdding(cell: self, index: routineItemCellList.count - 1)
    }
    
    private func addRoutineItemCell(){
        let cell = getRoutineItemCell(item: RoutineItemData())
        cell.selectDistance = { newDistance in
            self.viewModel?.routineStorage.update(distance: newDistance,
                                                  setTitle: self.routineSetTitle,
                                                  index: self.routineItemCellList.count-1)
        }
        
        cell.selectTime = { newTime in
            self.viewModel?.routineStorage.update(time: newTime,
                                                  setTitle: self.routineSetTitle,
                                                  index: self.routineItemCellList.count-1)
        }
        cell.isEditingMode = true
        routineItemCellList.append(cell)
        tableView.reloadData()
        
        print("cell.editingStyle = \(cell.editingStyle.rawValue)")
    }
}

//MARK: UI
extension RoutineSetTVC {
    private func setupLayout(){
        addSubviews([titleLabel,
                     reorderImageView,
                     tableBackgroundView])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(24)
        }
       
        reorderImageView.snp.makeConstraints{
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
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
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-40)
        }
        
        timeLabel.snp.makeConstraints{
            $0.centerY.equalTo(strokeLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(strokeLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    public func changeLayoutAtEditingMode(){
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(46)
        }
        
        distanceLabel.snp.updateConstraints{
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-32)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-82)
        }
    }
    
    public func turnToInitLayout(){
        strokeLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(24)
        }
        
        distanceLabel.snp.updateConstraints{
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-40)
        }
        
        timeLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
    
    public func updateReorderImageView(){
        print("reorderControlImageView?.frame = \(reorderControlImageView?.frame)")
        reorderImageView.snp.remakeConstraints{
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(reorderControlImageView?.frame.height ?? 30)
//            $0.width.equalTo(reorderControlImageView?.frame.width ?? 30)
            $0.height.equalTo(30)
            $0.width.equalTo(30)

        }
    }
}

