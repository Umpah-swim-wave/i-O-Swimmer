//
//  MakeAlert+UIViewController.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/21.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIView {
    func makeRequestAlert(title : String? = nil,
                          message : String? = nil,
                          okAction : ((UIAlertAction) -> Void)?,
                          cancelAction : ((UIAlertAction) -> Void)? = nil,
                          completion : ((UIAlertController) -> Void)? = nil)
    {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "변경 사항 폐기", style: .destructive, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
    }
}
