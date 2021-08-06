//
//  RoutineSetTVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/06.
//

import UIKit
import SnapKit
import Then

class RoutineSetTVC: UITableViewCell {
    static let identifier = "RoutineSetTVC"
    
    private var routineItemList: [RoutineItemData]?
    
    private var titleLabel = UILabel().then{
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .black
    }
    private var tableBackgroundView = UIView().then{
        $0.backgroundColor = .white
    }
    
    private var strokeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    private var tableView = UITableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout(){
        addSubviews([titleLabel,
                     tableBackgroundView])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tableBackgroundView.snp.makeConstraints{
            $0.top.equalTo(titleLabel).inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        tableBackgroundView.addSubviews([strokeLabel,
                                         tableView])
        
        strokeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(strokeLabel.snp.bottom).inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func registerXib(){
        tableView.registerCustomXib(name: RoutineItemTVC.identifier)
    }
    
    private func setTableViewAttribute(){
   
    }
    
    public func setRoutineContent(title: String, itemList: [RoutineItemData]){
        titleLabel.text = title
        routineItemList = itemList
    }
    
}

extension RoutineSetTVC: UITableViewDelegate{
    
}

extension RoutineSetTVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineItemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineItemTVC.identifier) as? RoutineItemTVC else {
            return UITableViewCell()
        }
        
        guard let itemList = routineItemList else {
            print("넘어온 아이템 리스트가 없음")
            return UITableViewCell()
        }
        
        cell.setRutineItem(item: itemList[indexPath.row])
        return cell
    }
    
}

