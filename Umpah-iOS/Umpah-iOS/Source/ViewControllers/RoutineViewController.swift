//
//  RoutineViewController.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class RoutineViewController: UIViewController {

    static let identifier = "RoutineViewController"
    private var viewModel = RoutineViewModel()
    private var disposeBag = DisposeBag()
    
    let upuhLightGreen =  UIColor(red: 246.0 / 255.0, green: 250.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    
    //MARK: TableView data
    private var tableCellList : [RoutineSetTVC] = []
    
    //MARK: - UI Component
    private let navigationView = UIView()
    private var tableView = UITableView()
    private let tableViewHeader = UIView()
    
    private lazy var bottomButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .blue
        $0.setTitle("어푸님만의 루틴 만들기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.addTarget(self, action: #selector(changeTableViewEditingMode), for: .touchUpInside)
    }
    
    private lazy var titleTextField = UITextField().then{
        $0.font = .boldSystemFont(ofSize: 20)
        $0.isUserInteractionEnabled = false
        $0.text = "1km 기본루틴"
        $0.returnKeyType = .done
        $0.delegate = self
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
        $0.textColor = .upuhBlack
        $0.backgroundColor = .clear
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
        setTableViewAttribute()
        bindViewModel()
        view.backgroundColor = upuhLightGreen
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
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
        updateTableView()
        if mode{
            titleTextField.becomeFirstResponder()
            descriptionTextView.isUserInteractionEnabled = true
        }else{
            descriptionTextView.isUserInteractionEnabled = false
        }
        
    }
    
    private func getRoutineSetCell(setTitle: String) -> RoutineSetTVC {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.identifier) as? RoutineSetTVC else { return RoutineSetTVC()}
        cell.setRoutineContent(title: setTitle, viewModel: viewModel)
        cell.isEditingMode = tableView.isEditing
        return cell
    }
    
    private func bindViewModel(){
        
        viewModel.routineStorage.getRoutineList()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { routineList in
                print("지금 불려서 다시 생성됨!")
                self.tableView.beginUpdates()
                var cellList : [RoutineSetTVC] = []
                self.viewModel.routineStorage.routineSetTitleList.forEach{
                    let cell = self.getRoutineSetCell(setTitle: $0)
                    cellList.append(cell)
                }
                self.tableCellList = cellList

                //self.tableView.reloadData()
                self.tableView.endUpdates()
            }).disposed(by: disposeBag)
        
        viewModel.routineStorage.getRoutineList()
            .bind(to: tableView.rx.items(cellIdentifier: RoutineSetTVC.identifier,
                                         cellType: RoutineSetTVC.self)){ (index, element, cell) in
                print("onNext 이벤트로 다시 불림!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                let routineTitle = self.viewModel.routineStorage.routineSetTitleList[index]
                
                cell.setRoutineContent(title: routineTitle, viewModel: self.viewModel)
                cell.isEditingMode = self.tableView.isEditing
                if self.tableCellList.count > index{
                    self.tableCellList.remove(at: index)
                    self.tableCellList.insert(cell, at: index)
                }else{
                    self.tableCellList.insert(cell, at: index)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setTableViewAttribute(){
        tableView.delegate = nil
        //tableView.dataSource = self
        tableView.registerCustomXib(name: RoutineSetTVC.identifier)
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = .clear
    }
    
    func updateTableView(){
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
}

extension RoutineViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let setTitle = viewModel.routineStorage.routineSetTitleList[indexPath.row]
        let routineCount = viewModel.routineStorage.routineList[setTitle]?.count ?? 0
        print("setTitle = \(setTitle), routineCount = \(routineCount)")
        return tableView.isEditing ? CGFloat(170 + routineCount * 44) : CGFloat(120 + routineCount * 44)
    }
    
    internal func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableCellList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension RoutineViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.routineStorage.routineSetTitleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellList[indexPath.row]
    }

}


extension RoutineViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

extension RoutineViewController {
    
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
            $0.trailing.equalToSuperview().inset(41)
        }
        
        titleUnderlineView.snp.makeConstraints{
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
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
    
}
