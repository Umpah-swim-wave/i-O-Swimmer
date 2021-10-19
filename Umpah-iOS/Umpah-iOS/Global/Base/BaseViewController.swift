//
//  BaseViewController.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class BaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    // MARK: - Rx
    
    public let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var tableViewContainer = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        render()
        configUI()
        setupLocalization()
        setData()
    }
    
    // MARK: - Manage Memory
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Method
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // 기본 음파 배경 설정
        view.backgroundColor = .upuhBlue
    }
    
    func setupLocalization() {
        // Override Localization
    }
    
    func setData() {
        // Override Set Data
    }
    
    // MARK: - @objc
    
    @objc
    func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
