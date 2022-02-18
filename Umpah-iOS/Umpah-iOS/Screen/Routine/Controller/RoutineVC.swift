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

class RoutineVC: BaseViewController {
    
    private var viewModel = RoutineViewModel()
    
    //MARK: TableView data
    private var routineSetCellList : [RoutineSetTVC] = []
    
    //MARK: - UI Component
    private let navigationView = UIView()
    private lazy var xmarkButton = XmarkButton(toDismiss: self)
    private let backButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "ic_back"), for: .normal)
    }
    
    private var tableView = UITableView()
    private let tableViewHeader = UIView()
    
    private lazy var bottomButton = UIButton().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 25
        $0.setBackgroundColor(.upuhBlue2, for: .normal)
        $0.setBackgroundColor(.upuhBlue2.withAlphaComponent(0.7), for: .highlighted)
        $0.setTitle("어푸님만의 루틴 저장하기", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 16)
        $0.titleLabel?.textColor = .white
        $0.addTarget(self, action: #selector(changeTableViewEditingMode), for: .touchUpInside)
    }
    
    private lazy var titleTextField = UITextField().then{
        $0.font = .IBMPlexSansSemiBold(ofSize: 20)
        $0.textColor = .upuhBlack
        $0.isUserInteractionEnabled = false
        $0.text = "1km 기본루틴"
        $0.returnKeyType = .done
        $0.delegate = self
    }
    private let titleUnderlineView = UIView()
    
    private let levelButton = UIButton().then{
        $0.setTitle("레벨", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.upuhBlack, for: .normal)
        $0.backgroundColor = .lightGray
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let distanceButton = UIButton().then{
        $0.setTitle("1km", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .upuhBadgeOrange
        $0.isUserInteractionEnabled = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let timeButton = UIButton().then{
        $0.setTitle("1h", for: .normal)
        $0.titleLabel?.font = .IBMPlexSansBold(ofSize: 12)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .upuhBadgeOrange
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    }
    
    private let descriptionTextView = UITextView().then{
        $0.text = "설명이 들어갑니다 오랜만에 수영을 하면 몸이 굳으니까 이걸로 몸을 푸는거라고 합니다 그렇다네요 최대두줄까지 들어가나요?"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.backgroundColor = .clear
        $0.textContainer.maximumNumberOfLines = 2
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.isUserInteractionEnabled = false
        let kernSpacing: CGFloat = -0.6
        let style = NSMutableParagraphStyle()
        style.lineSpacing = -0.9
        $0.attributedText = NSAttributedString(string: $0.text, attributes: [.paragraphStyle: style,
                                                                             .kern: kernSpacing,
                                                                             .foregroundColor: UIColor.upuhBlack,
                                                                             .font: UIFont.IBMPlexSansText(ofSize: 14)])
        $0.typingAttributes = [.paragraphStyle: style,
                               .kern: kernSpacing,
                               .foregroundColor: UIColor.upuhBlack,
                               .font: UIFont.IBMPlexSansText(ofSize: 14)]
    }
    
    private let headerUnderlineView = UIView().then{
        $0.backgroundColor = .upuhSubGray
    }
    
    //MARK: abouy Modify element
    //var presentedRoutineitem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setTableViewAttribute()
        initRoutineSetCells()
        addTapGesture()
        bind()
        view.backgroundColor = .upuhBackground
    }
    
    private func updateHeaderLayout(atEditMode: Bool){
        if atEditMode {
            tableViewHeader.frame = CGRect(x: 0, y: 0,
                                           width: UIScreen.getDeviceWidth(),
                                           height: tableViewHeader.frame.height + 8)
        }else {
            tableViewHeader.frame = CGRect(x: 0,y: 0,
                                           width: UIScreen.getDeviceWidth(),
                                           height: tableViewHeader.frame.height - 8)
        }
        
        let offsetValue = atEditMode ? 8 : 0
        titleUnderlineView.snp.updateConstraints{
            $0.top.equalTo(titleTextField.snp.bottom).offset(offsetValue)
        }
        
        titleUnderlineView.backgroundColor = atEditMode ? .upuhSubGray : .clear
        titleTextField.isUserInteractionEnabled = atEditMode ? true : false
        titleTextField.text = atEditMode ? "Copy of " + titleTextField.text! : titleTextField.text
    }
    
    private func setTableViewAttribute(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCustomXib(name: RoutineSetTVC.className)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .upuhBackground
    }
    
    
    private func initRoutineSetCells(){
        viewModel.routineStorage.routineSetTitleList.forEach{
            print("setTitle = \($0)")
            let cell = getInitRoutineSetCell(setTitle: $0)
            routineSetCellList.append(cell)
        }
        print(routineSetCellList.count)
    }
    
    private func getInitRoutineSetCell(setTitle: String) -> RoutineSetTVC{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.className) as? RoutineSetTVC else {
            return RoutineSetTVC() }
        cell.setRoutineContent(title: setTitle, viewModel: viewModel)
        cell.cellDelegate = self
        cell.isEditingMode = tableView.isEditing
        for index in 0..<cell.routineItemCellList.count {
            cell.routineItemCellList[index].selectStorke = { [weak self] strokeName in
                self?.presentToModifyElementView(of: .stroke,
                                                 setTitle: setTitle,
                                                 index: index,
                                                 before: strokeName)
            }
        }
        return cell
    }
    
    private func getNewInitRoutineSetCell(setTitle: String) -> RoutineSetTVC{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSetTVC.className) as? RoutineSetTVC else {
            return RoutineSetTVC() }
        cell.setRoutineContent(title: setTitle, viewModel: viewModel)
        cell.cellDelegate = self
        cell.isEditingMode = true
        for index in 0..<cell.routineItemCellList.count {
            cell.routineItemCellList[index].selectStorke = { [weak self] strokeName in
                self?.presentToModifyElementView(of: .stroke,
                                                 setTitle: setTitle,
                                                 index: index,
                                                 before: strokeName)
            }
            cell.routineItemCellList[index].isEditingMode = true
            cell.tableView.setEditing(true, animated: true)
            print("cell.routineItemCellList[index].showsReorderControl = \(cell.routineItemCellList[index].showsReorderControl)")
        }
        return cell
    }
    
    @objc
    func changeTableViewEditingMode(){
        print("changeTableViewEditingMode")
        let mode = tableView.isEditing ? false : true
        tableView.isEditing = mode
        tableView.tableFooterView = mode ? getFooterViewLayout() : nil
        updateHeaderLayout(atEditMode: mode)
        routineSetCellList.forEach{
            $0.tableView.setEditing(mode, animated: true)
            $0.isEditingMode = mode
        }
        tableView.reloadData()
        routineSetCellList.forEach{
            $0.updateReorderImageView()
            $0.reorderImageView.isHidden = !mode
        }
        if mode {
            titleTextField.becomeFirstResponder()
            descriptionTextView.isUserInteractionEnabled = true
        }else{
            descriptionTextView.isUserInteractionEnabled = false
        }
        
        if !backButton.isHidden{
            backButton.isHidden = true
            xmarkButton.isHidden = false
        }
    }
    
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func bind(){
        viewModel.routineStorage.store
            .subscribe(onNext: { _ in
                self.distanceButton.setTitle(self.viewModel.getTotalRoutinesDistanceToString(), for: .normal)
                self.timeButton.setTitle(self.viewModel.getTotalRoutinesTimeToString(), for: .normal)
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate
extension RoutineVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let routineCount = viewModel.getRoutineItemCount(index: indexPath.row)
        return tableView.isEditing ? CGFloat(170 + routineCount * 44) : CGFloat(120 + routineCount * 44)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageView = cell.subviews.first(where: {$0.description.contains("Reorder")})?
            .subviews.first(where: {$0 is UIImageView}) as? UIImageView
        print("imageView reorder = \(imageView?.frame)")
        imageView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        routineSetCellList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        viewModel.routineStorage.routineSetTitleList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

//MARK: - UITableViewDataSource
extension RoutineVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineSetCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return routineSetCellList[indexPath.row]
    }
}

extension RoutineVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - RoutineCellDelegate
extension RoutineVC: RoutineCellDelegate{
    func routineItemCellForAdding(cell: RoutineSetTVC, index: Int) {
        cell.routineItemCellList[index].selectStorke = { [weak self] strokeName in
            self?.presentToModifyElementView(of: .stroke,
                                             setTitle: cell.routineSetTitle,
                                             index: index,
                                             before: strokeName)
        }
        updateTableView()
    }
    
    func routineItemCellForDeleting(cell: RoutineSetTVC, index: Int) {
        let index = cell.getTableCellIndexPathRow()
        resetRoutineItemPresentIndex(cell: cell)
        updateTableView()
    }
    
    func routineItenCellForSwapping(cell: RoutineSetTVC, source: Int, destination: Int) {
        resetRoutineItemPresentIndex(cell: cell)
    }
    
    func updateTableView(){
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func resetRoutineItemPresentIndex(cell: RoutineSetTVC){
        for index in 0..<cell.routineItemCellList.count{
            cell.routineItemCellList[index].selectStorke = { [weak self] strokeName in
                self?.presentToModifyElementView(of: .stroke,
                                                 setTitle: cell.routineSetTitle,
                                                 index: index,
                                                 before: strokeName)
            }
        }
    }
}

//MARK: - TextView Delegate


//MARK: - Modify Element
extension RoutineVC {
    func presentToModifyElementView(of type: ModifyElementType, setTitle: String = "", index: Int = 0, before data: String = ""){
        let storyboard = UIStoryboard(name: "ModifyElement", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(identifier: ModifyElementVC.className) as? ModifyElementVC else {
            return
        }
        nextVC.setupModificationContent(of: type,
                                        setTitle: setTitle,
                                        index: index, before: data)
        nextVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            nextVC.backgroundImage = self.view.asImage()
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
        })
    }
    
    func updateRoutineItem(stroke: String, setTitle: String, index: Int){
        viewModel.routineStorage.update(stroke: stroke, setTitle: setTitle, index: index)
        let origin = viewModel.routineStorage.routineList[setTitle]?[index] ?? RoutineItemData()
        let newItem = RoutineItemData(stroke: stroke, distance: origin.distance, time: origin.time)
        routineSetCellList.forEach{
            if $0.routineSetTitle == setTitle {
                $0.routineItemCellList[index].setRoutineItem(item: newItem, isEditing: true)
                $0.tableView.reloadData()
            }
        }
    }
}

//MARK: - configure UI
extension RoutineVC {
    private func setupConstraints(){
        view.addSubviews([navigationView,
                          tableView,
                          bottomButton])
        
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        setupNavigationViewLayout()
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(49)
        }
        setupHeaderViewLayout()
        bottomButton.bringSubviewToFront(tableView)
    }
    
    private func setupNavigationViewLayout(){
        navigationView.addSubviews([backButton, xmarkButton])
        
        backButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        xmarkButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        xmarkButton.isHidden = true
    }
    
    private func setupHeaderViewLayout(){
        tableViewHeader.frame = CGRect(x: 0, y: 0,
                                       width: UIScreen.getDeviceWidth(),
                                       height: 168)
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
            $0.top.equalTo(titleUnderlineView.snp.bottom).offset(5)
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
            $0.height.equalTo(40)
        }
        
        headerUnderlineView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.8)
        }
        
        tableView.tableHeaderView = tableViewHeader
    }
    
    func getFooterViewLayout() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 68))
        
        let titleButton = UIButton().then{
            $0.setTitle("세트 추가하기", for: .normal)
            $0.titleLabel?.font = .IBMPlexSansSemiBold(ofSize: 14)
            $0.setTitleColor(.upuhGreen, for: .normal)
        }
        
        let titleUnderline = UIView().then{
            $0.backgroundColor = .upuhGreen
        }
        
        let presentingAction = UIAction{ [weak self] _ in
            self?.presentToModifyElementView(of: .setTitle)
        }
        
        titleButton.addAction(presentingAction, for: .touchUpInside)
        
        view.addSubviews([titleButton,
                          titleUnderline])
        
        titleButton.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    
        titleUnderline.snp.makeConstraints{
            $0.top.equalTo(titleButton.snp.bottom).offset(-10)
            $0.centerX.equalTo(titleButton.snp.centerX)
            $0.width.equalTo(titleButton.snp.width)
            $0.height.equalTo(1.5)
        }
        return view
    }
    
    func addRoutineSet(setTitle: String){
        if setTitle == "" {return}
        viewModel.routineStorage.routineSetTitleList.append(setTitle)
        viewModel.routineStorage.routineList[setTitle] = [RoutineItemData()]
        let cell = getNewInitRoutineSetCell(setTitle: setTitle)
        cell.reorderImageView.isHidden = false
        routineSetCellList.append(cell)
        tableView.reloadData()
    }
}
