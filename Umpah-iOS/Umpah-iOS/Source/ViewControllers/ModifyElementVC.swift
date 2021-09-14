//
//  ModifySelectionVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import UIKit
import RxSwift
import RxCocoa

class ModifyElementVC: UIViewController, UIScrollViewDelegate {

    static let identifier = "ModifyElementVC"
    private var disposeBag = DisposeBag()
    
    public var elementList: [String] = []
    
    private var backgroundImageView = UIImageView()
    public var backgroundImage : UIImage?
    
    private var contentViewHeight = 0
    
    private var dimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    public var titleLabel = UILabel().then{
        $0.textColor = .upuhBlack()
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    public var contentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var tableView = UITableView().then {
        $0.registerCustomXib(name: ModifyElementTVC.identifier)
        $0.rowHeight = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateContentViewHeight()
        setupBackgroundLayout()
        setupContentViewLayout()
        bindDataToTableView()
    }
    
    func calculateContentViewHeight(){
        contentViewHeight = elementList.count * 40 + 98
    }
    
    func bindDataToTableView(){
        let observable = Observable.of(elementList)
        observable.bind(to: tableView.rx.items(cellIdentifier: ModifyElementTVC.identifier,
                                               cellType: ModifyElementTVC.self)) { row, element, cell in
            cell.nameLabel.text = element
        }.disposed(by: disposeBag)
    }
}

extension ModifyElementVC {
    private func setupBackgroundLayout(){
        view.addSubview(backgroundImageView)
        backgroundImageView.image = backgroundImage
        backgroundImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(dimmerView)
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
            $0.top.equalToSuperview().inset(32)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).inset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
