//
//  XmarkButton.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/08/05.
//

import UIKit

class XmarkButton: UIButton {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(toDismiss vc: UIViewController) {
        super.init(frame: .zero)
        setupConfigure()
        initAction(vc: vc)
    }
    
    private func setupConfigure() {
        setImage(UIImage(named: "ic_xmark"), for: .normal)
    }
    
    private func initAction(vc: UIViewController) {
        let dismissAction = UIAction { _ in
            vc.dismiss(animated: true, completion: nil)
        }
        addAction(dismissAction, for: .touchUpInside)
    }

}
