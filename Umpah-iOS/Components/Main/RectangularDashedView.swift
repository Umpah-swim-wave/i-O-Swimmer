//
//  RectangularDashedView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit

class RectangularDashedView: UIView {
    // MARK: - Lazy Properties
    var infoLabel = UILabel().then {
        $0.text = "오늘은 어떤 루틴으로\n수영하실 건가요?"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    // MARK: - Properties
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    var dashWidth: CGFloat = 0
    var dashColor: UIColor = .clear
    var dashLength: CGFloat = 0
    var betweenDashesSpace: CGFloat = 0
    var dashBorder: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dashBorder?.removeFromSuperlayer()
        
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
    
    private func setupLayout() {
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
