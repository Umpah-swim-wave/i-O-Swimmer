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

class BaseViewController: UIViewController {
    
    // MARK:- Rx
    public let disposeBag = DisposeBag()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        setupLayout()
        configUI()
        setupLocalization()
        setData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Method
    func setupLayout() {
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
    
    func bind() {
        // Override Binding
    }
    
    // MARK: - @objc
    @objc
    func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
}
