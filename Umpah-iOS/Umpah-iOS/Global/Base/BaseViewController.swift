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
    
    public lazy var baseTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        render()
        setTableView(tableView: baseTableView)
        configUI()
        setLocalization()
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
    
    func setTableView(tableView table: UITableView) {
        // Override setTableView
    }
    
    func configUI() {
        // 기본 음파 배경 설정
        view.backgroundColor = .upuhBlue
    }
    
    func setLocalization() {
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
