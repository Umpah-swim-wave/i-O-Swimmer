//
//  BaseViewController.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/19.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
        
    // MARK: - properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }
    
    // MARK: - Override Method
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // configuration
        view.backgroundColor = .upuhBlue
    }

    // MARK: - @objc
    
    @objc
    func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
}
