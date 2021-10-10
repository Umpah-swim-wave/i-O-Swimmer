//
//  RoutineItemTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/05.
//

import UIKit
import SnapKit
import Then

class RoutineItemTVC: UITableViewCell {
    static let identifier = "RoutineItemTVC"
    
    public var selectStorke: (() -> ())?
    public var selectDistance: ((Int) -> ())?
    public var isSelectedDistance: Bool = true
    private var routineItem: RoutineItemData?
    
    private var distanceList: [Int] = []
    private var miniteList: [Int] = []
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    
    public var strokeButton = UIButton().then{
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        $0.setTitleColor(.upuhBlack, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = .IBMPlexSansRegular(ofSize: 14)
    }
    
    private var distanceTextField = UITextField().then {
        $0.font = .IBMPlexSansRegular(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.tintColor = .clear
    }
    
    private var timeTextField = UITextField().then {
        $0.font = .IBMPlexSansRegular(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.tintColor = .clear
    }
    
    public var lineView = UIView().then {
        $0.backgroundColor = .upuhSubGray
    }
    
    public var isEditingMode: Bool = false {
        didSet{
            if isEditingMode{
                changeLayoutAtEditingMode()
                strokeButton.setImage(UIImage(named: "chevronDown"), for: .normal)
            }else{
                turnToInitLayout()
                strokeButton.setImage(nil, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initDataList()
        setupLayout()
        addActions()
        createPickerViewToolbar()
        setPickerViewDelegate()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setRoutineItem(item: RoutineItemData, isEditing: Bool){
        routineItem = item
        strokeButton.setTitle(item.stroke, for: .normal)
        distanceTextField.text = "\(item.distance)m"
        timeTextField.text = item.getTimeToString()
        isEditingMode = isEditing
    }
    
    private func setContentText(){
        guard let item = routineItem else {
            print("넘겨져온 item이 없음")
            return
        }
        strokeButton.setTitle(item.stroke, for: .normal)
        distanceTextField.text = "\(item.distance)m"
        timeTextField.text = item.getTimeToString()
    }
    
    func addActions(){
        let touchUpToselectStorke = UIAction {_ in self.selectStorke?()}
        let checkDistanceAction = UIAction{ _ in self.isSelectedDistance = true}
        let checkTimeAction = UIAction{_ in self.isSelectedDistance = false}
        
        strokeButton.addAction(touchUpToselectStorke, for: .touchUpInside)
        distanceTextField.addAction(checkDistanceAction, for: .touchDown)
        timeTextField.addAction(checkTimeAction, for: .touchDown)
    }
    
    func setPickerViewDelegate(){
        pickerView.delegate = self
        pickerView.dataSource = self
        distanceTextField.inputView = pickerView
        distanceTextField.inputAccessoryView = toolbar
    }
    
    func initDataList(){
        for num in stride(from: 25, to: 9999, by: 25){
            distanceList.append(num)
        }
        for num in 0..<60 {
            miniteList.append(num)
        }
    }
    
    private func createPickerViewToolbar(){
        toolbar.sizeToFit()
        
        let titleLabel = UIBarButtonItem(title: "거리", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(donePresseed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)
    }
    
    @objc
    func donePresseed(){
        endEditing(true)
        selectDistance?(routineItem?.distance ?? 9999)
    }
}


extension RoutineItemTVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(distanceList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distanceTextField.text = "\(distanceList[row])m"
        routineItem?.distance = distanceList[row]
    }
    
}

extension RoutineItemTVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  distanceList.count
    }
}


//MARK: UI
extension RoutineItemTVC {
    private func setupLayout(){
        addSubviews([strokeButton,
                     distanceTextField,
                     timeTextField,
                     lineView])

        strokeButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(108)
        }
        
        distanceTextField.snp.makeConstraints{
            $0.centerY.equalTo(strokeButton.snp.centerY)
            $0.trailing.equalTo(timeTextField.snp.leading).offset(-37)
        }
        
        timeTextField.snp.makeConstraints {
            $0.centerY.equalTo(strokeButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        print("Editing = \(isEditingMode)")
        print("showsReorderControl = \(showsReorderControl)")
        if showsReorderControl{
            changeLayoutAtEditingMode()
        }else{
            turnToInitLayout()
        }
    }
    
    public func changeLayoutAtEditingMode(){
        strokeButton.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(46)
        }
        
        timeTextField.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-55)
        }
    }
    
    public func turnToInitLayout(){
        strokeButton.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(24)
        }
        
        timeTextField.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
