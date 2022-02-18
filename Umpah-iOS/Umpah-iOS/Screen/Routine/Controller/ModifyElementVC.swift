//
//  ModifySelectionVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import UIKit
import RxSwift
import RxCocoa

enum ModifyElementType {
    case setTitle
    case stroke
    case exceptStorke
    case level
}

class ModifyElementVC: UIViewController{

    static let identifier = "ModifyElementVC"
    private var disposeBag = DisposeBag()
    private let maxLength = 9
    
    public var elementList: [String] = []
    public var elementType: ModifyElementType?
    
    public var presentingSetTitle: String?
    public var presentingItemIndex: Int?
    public var selectedContent: String?
    
    private var backgroundImageView = UIImageView()
    public var backgroundImage : UIImage?
    
    private var contentViewHeight = 0
    
    var sendFilterData: (() -> Void)?
    
    private var dimmerView = UIView().then{
        $0.backgroundColor = .black
        $0.alpha = 0.6
    }
    
    public var titleLabel = UILabel().then{
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 18)
    }
    
    public var contentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var tableView = UITableView().then {
        $0.registerCustomXib(name: ModifyElementTVC.identifier)
        $0.rowHeight = 40
        $0.layer.cornerRadius = 16
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    lazy var checkImageView = UIImageView().then{
        $0.image = UIImage(named: "checkIcon")
        $0.isHidden = true
    }
    
    lazy var storkeTextField = UITextField().then{
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansRegular(ofSize: 16)
        $0.text = "직접 등록하기"
        $0.placeholder = "원하는 영법을 입력해보세요"
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentElement()
        calculateContentViewHeight()
        setupBackgroundLayout()
        setupContentViewLayout()
        bindDataToTableView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
            if isBackgroundTouched(point: position) {
                changeDataInPresentingVC()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func changeDataInPresentingVC(){
        switch elementType{
        case .setTitle:
            let presentingVC = presentingViewController as? RoutineVC
            presentingVC?.addRoutineSet(setTitle: selectedContent ?? "타이틀 잘못 넘어옴")
        case .stroke:
            let presentingVC = presentingViewController as? RoutineVC
            presentingVC?.updateRoutineItem(stroke: self.selectedContent ?? "잘못넘어옴",
                                            setTitle: self.presentingSetTitle ?? "",
                                            index: self.presentingItemIndex ?? 0)
        case .level:
            let presentingVC = presentingViewController as? MainVC
            presentingVC?.cardView.expandedView.routineFilterView.levelText = selectedContent ?? "레벨"
            sendFilterData?()
        case .exceptStorke:
            let presentingVC = presentingViewController as? MainVC
            presentingVC?.cardView.expandedView.routineFilterView.exceptionStrokeText = selectedContent ?? "제외할 영법"
            sendFilterData?()
        case .none:
            elementList = []
        }
    }
    
    func isBackgroundTouched(point: CGPoint) -> Bool{
        if point.x > contentView.frame.minX
            && point.x < contentView.frame.maxX
            && point.y > contentView.frame.minY
            && point.y < contentView.frame.maxY{
           return false
        }
        return true
    }
    
    func calculateContentViewHeight(){
        if elementType == .stroke {
            contentViewHeight = (elementList.count + 1) * 40 + 98
        }else{
            contentViewHeight = elementList.count * 40 + 98
        }
        
    }
    
    func bindDataToTableView(){
        let observable = Observable.of(elementList)
        observable.bind(to: tableView.rx.items(cellIdentifier: ModifyElementTVC.identifier,
                                               cellType: ModifyElementTVC.self)) { row, element, cell in
            if self.elementType == .setTitle {
                cell.nameLabel.text = element + " SET"
            }else{
                cell.nameLabel.text = element
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedContent = self.elementList[indexPath.row]
                print("self.selectedContent= \(self.selectedContent)")
                self.changeDataInPresentingVC()
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    
    private func setupContentElement(){
        switch elementType{
        case .setTitle:
            elementList = ["WARM-UP", "PRE", "MAIN", "KICK", "PULL", "DRILL", "COOL DOWN"]
            titleLabel.text = "세트 선택"
        case .level:
            elementList = ["초급", "중급","고급"]
            titleLabel.text = "레벨 선택"
        case .stroke:
            elementList = ["자유형", "평영", "배영", "접영"]
            titleLabel.text = "영법 선택"
            regiserTableViewFooterToWriteStroke()
        case .exceptStorke:
            elementList = ["자유형", "평영", "배영", "접영"]
            titleLabel.text = "제외할 영법 선택"
        case .none:
            elementList = []
        }
    }
//    
//    private func changeLevelStringToInt(level: String) -> Int{
//        switch level{
//        case "초급":
//            return 0
//        case "중급":
//            return 1
//        case "고급":
//            return 2
//        default:
//            return -1
//        }
//    }
    
}

extension ModifyElementVC {
    private func setupBackgroundLayout(){
        view.addSubviews([backgroundImageView,dimmerView])
        backgroundImageView.image = backgroundImage
        backgroundImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        dimmerView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupContentViewLayout(){
        view.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(contentViewHeight)
        }
        
        contentView.addSubviews([titleLabel, tableView])
        
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func regiserTableViewFooterToWriteStroke(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        view.addSubviews([storkeTextField, checkImageView])
        storkeTextField.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
        }
        
        checkImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(32)
        }
        
        tableView.tableFooterView = view
    }
}


extension ModifyElementVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        storkeTextField.text = nil
        storkeTextField.font = .IBMPlexSansSemiBold(ofSize: 16)
        storkeTextField.textColor = .upuhBlue
        checkImageView.isHidden = false
        
        contentView.frame = CGRect(x: contentView.frame.minX,
                                   y: contentView.frame.minY - 100,
                                   width: contentView.frame.width,
                                   height: contentView.frame.height)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        guard let text = textField.text else {return false}
        selectedContent = text
        changeDataInPresentingVC()
        dismiss(animated: true, completion: nil)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contentView.frame = CGRect(x: contentView.frame.minX,
                                   y: contentView.frame.minY + 100,
                                   width: contentView.frame.width,
                                   height: contentView.frame.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        if text.count > maxLength {
            textField.deleteBackward()
        }
        
        return true
    }
}

