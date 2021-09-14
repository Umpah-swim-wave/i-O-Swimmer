//
//  RoutineVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/03.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class RoutineVC: UIViewController {

    static let identifier = "RoutineVC"
    //private var viewModel = RoutineViewModel()
    private var disposeBag = DisposeBag()
    
    //MARK: TableView data
    private var routineList: [String : [RoutineItemData]] = [:]
    private var tableCellList : [RoutineSetTVC] = []
    private var tableSetTitleList : [String] = ["warm-up", "main", "cool-down"]
    
    private let upuhGreen = UIColor(red: 0.965, green: 0.98, blue: 0.988, alpha: 1)
    //MARK: - UI Component
    private let navigationView = UIView()
    private var tableView = UITableView().then{
        $0.registerCustomXib(name: RoutineSetTVC.identifier)
    }
    
    private var bottomButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .blue
        $0.setTitle("어푸님만의 루틴 만들기", for: .normal)
        $0.titleLabel?.textColor = .white
    }
    
    private let tableViewHeader = UIView()
    
    private let titleTextField = UITextField().then{
        $0.font = .boldSystemFont(ofSize: 20)
        $0.isUserInteractionEnabled = false
        $0.text = "1km 기본루틴"
        $0.returnKeyType = .done
    }
    private let titleUnderlineView = UIView()
    
    private let levelButton = UIButton().then{
        $0.setTitle("레벨", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .lightGray
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let distanceButton = UIButton().then{
        $0.setTitle("1km", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .orange
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let timeButton = UIButton().then{
        $0.setTitle("1h", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .orange
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let descriptionTextView = UITextView().then{
        $0.text = "설명이 들어갑니다 오랜만에 수영을 하면 몸이 굳으니까 이걸로 몸을 푸는거라고 합니다 그렇다네요 최대두줄까지 들어가나요?"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .black
        $0.backgroundColor = UIColor(red: 0.965, green: 0.98, blue: 0.988, alpha: 1)
        //$0.isScrollEnabled = false
        $0.textContainer.maximumNumberOfLines = 2
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.isUserInteractionEnabled = false
    }
    
    private let headerUnderlineView = UIView().then{
        $0.backgroundColor = .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        initRoutineItem()
        initRoutineSetCells()
        setTableViewAttribute()
        addActions()
        view.backgroundColor = upuhGreen
    }
    
    private func updateHeaderLayout(atEditMode: Bool){
        let offsetValue = atEditMode ? 8 : 0
        titleUnderlineView.snp.updateConstraints{
            $0.top.equalTo(titleTextField.snp.bottom).offset(offsetValue)
        }
        descriptionTextView.snp.updateConstraints{
            $0.bottom.equalToSuperview().inset(24 - offsetValue)
        }
        titleUnderlineView.backgroundColor = atEditMode ? .black : .clear
        titleTextField.isUserInteractionEnabled = atEditMode ? true : false
        titleTextField.text = atEditMode ? "Copy of " + titleTextField.text! : titleTextField.text
    }

    private func setTableViewAttribute(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = upuhGreen
    }
    
    private func initTableViewHeader(title: String, level: String, description: String){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 164))
    }
    
    //MARK: TODO - 나중에 서버 통신 연결 후 변경
    private func initRoutineItem(){
        routineList = ["warm-up" : [RoutineItemData(stroke: "자유영", distance: "90", time: 135),
                                    RoutineItemData(stroke: "자유영", distance: "250", time: 235),
                                    RoutineItemData(stroke: "자유영", distance: "1275", time: 335)] ,
                       "main" : [RoutineItemData(stroke: "배형", distance: "1225", time: 130),
                                 RoutineItemData(stroke: "배형", distance: "1250", time: 131),
                                 RoutineItemData(stroke: "배형", distance: "1275", time: 132),
                                 RoutineItemData(stroke: "배형", distance: "1300", time: 133),
                                 RoutineItemData(stroke: "배형", distance: "1225", time: 134)],
                       "cool-down" : [RoutineItemData(stroke: "접형", distance: "1200", time: 100),
                                 RoutineItemData(stroke: "접형", distance: "1225", time: 200),
                                 RoutineItemData(stroke: "접형", distance: "1250", time: 300),
                                 RoutineItemData(stroke: "접형", distance: "1275", time: 400)]]
    }
    
    private func initRoutineSetCells(){
        tableSetTitleList.forEach{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.identifier) as? RoutineSetTVC else { return }
            cell.setRoutineContent(title: $0, itemList: routineList[$0] ?? [])
            cell.cellDelegate = self
            //cell.viewModel = viewModel
            tableCellList.append(cell)
        }
    }
    private func addActions(){
        bottomButton.addTarget(self, action: #selector(changeTableViewEditingMode), for: .touchUpInside)
    }
    
    @objc
    func changeTableViewEditingMode(){
        let mode = tableView.isEditing ? false : true
        tableView.isEditing = mode
        tableView.tableFooterView = mode ? getFooterViewLayout() : nil
        updateHeaderLayout(atEditMode: mode)
        tableCellList.forEach{
            $0.tableView.setEditing(mode, animated: true)
            $0.isEditingMode = mode
        }
        tableView.reloadData()
        tableCellList.forEach{
            if $0.showsReorderControl {
                //$0.reorderControlImageView?.frame = CGRect(x: 0, y: 0, width: 25, height: 13)
                print("---------------------------------")
                print("\($0.reorderControlImageView)")
                print("---------------------------------")
            }
        }
    }
    
//    private func bindViewModel(){
//
//        for title in viewModel.routineSetTitleList {
//            viewModel.routineSubjectList[title]?.bind(to: tableView.rx.items){ (tableView, row, item) -> UITableViewCell in
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.identifier) as? RoutineSetTVC else { return UITableViewCell()}
//                cell.setRoutineContent(title: title)
//                cell.viewModel = self.viewModel
//                return cell
//            }.disposed(by: disposeBag)
//        }
//    }
}

extension RoutineVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let setTitle = tableSetTitleList[indexPath.row]
        let routineCount = routineList[setTitle]?.count ?? 0
        return tableView.isEditing ? CGFloat(170 + routineCount * 44) : CGFloat(120 + routineCount * 44)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableCellList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension RoutineVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSetTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellList[indexPath.row]
    }
}

extension RoutineVC: RoutineCellDelegate{
    func routineItemCellForAdding(cell: RoutineSetTVC) {
        print("이거 왜 안눌려??")
        let index = cell.getTableCellIndexPathRow()
//        routineList[cell.setTitle]?.append(RoutineItemData())
//        tableCellList[index].routineItemList = routineList[cell.setTitle] ?? []
        updateTableView()
    }
    
    func routineItemCellForDeleting(cell: RoutineSetTVC, index: Int) {
        let index = cell.getTableCellIndexPathRow()
       // routineList[cell.setTitle]?.remove(at: index)
        updateTableView()
    }
    
    func updateTableView(){
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
}

extension RoutineVC {
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
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(40)
        }
        setupHeaderViewLayout()
        bottomButton.bringSubviewToFront(tableView)
    }
    
    private func setupHeaderViewLayout(){
        tableViewHeader.frame = CGRect(x: 0, y: 0,
                                       width: UIScreen.getDeviceWidth(),
                                       height: 164)
        tableViewHeader.backgroundColor = .clear
        tableViewHeader.addSubviews([titleTextField,
                                     titleUnderlineView,
                                     levelButton,
                                     distanceButton,
                                     timeButton,
                                     descriptionTextView,
                                     headerUnderlineView])
        
        titleTextField.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(28)
        }
        
        titleUnderlineView.snp.makeConstraints{
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.leading.equalTo(titleTextField.snp.leading)
            $0.trailing.equalToSuperview().inset(41)
            $0.height.equalTo(1)
        }
        
        levelButton.snp.makeConstraints{
            $0.top.equalTo(titleUnderlineView.snp.bottom).offset(12)
            $0.leading.equalTo(titleTextField.snp.leading)
            $0.height.equalTo(24)
        }
        
        distanceButton.snp.makeConstraints{
            $0.centerY.equalTo(levelButton.snp.centerY)
            $0.leading.equalTo(levelButton.snp.trailing).offset(8)
            $0.height.equalTo(24)
        }
        
        timeButton.snp.makeConstraints{
            $0.centerY.equalTo(levelButton.snp.centerY)
            $0.leading.equalTo(distanceButton.snp.trailing).offset(8)
            $0.height.equalTo(24)
        }
        
        descriptionTextView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(levelButton.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        headerUnderlineView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        tableView.tableHeaderView = tableViewHeader
    }
    
    func getFooterViewLayout() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 68))

        let titleButton = UIButton().then{
            $0.setTitle("세트 추가하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitleColor(.gray, for: .normal)
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
}
