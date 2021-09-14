//
//  ModifySelectionVC.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/07.
//

import UIKit
import RxSwift
import RxCocoa

class ModifyElementVC: UIViewController{

    static let identifier = "ModifyElementVC"
    private var disposeBag = DisposeBag()
    
    public var elementList: [String] = []
    
    private var backgroundImageView = UIImageView()
    public var backgroundImage : UIImage?
    
    private var contentViewHeight = 0
    
    private var dimmerView = UIView().then{
        $0.backgroundColor = .black
        $0.alpha = 0.6
    }
    
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
        $0.layer.cornerRadius = 16
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                dismiss(animated: false, completion: nil)
            }
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
        contentViewHeight = elementList.count * Int((tableView.rowHeight)) + 98
        print("contentViewHeight = \(contentViewHeight)")
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
            $0.top.equalToSuperview().offset(32)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
