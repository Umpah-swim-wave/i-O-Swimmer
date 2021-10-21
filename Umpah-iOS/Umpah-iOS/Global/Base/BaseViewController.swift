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

class BaseViewController: UIViewController{
        
    // MARK: - Rx
    
    public let disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        render()
        configUI()
        setLocalization()
        setData()
    }
    
    // MARK: - Manage Memory
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit BaseViewController instance")
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
}
