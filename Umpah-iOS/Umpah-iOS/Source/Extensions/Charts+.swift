//
//  Charts+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/08.
//

import Foundation
import Charts

extension CombinedChartView {
    func setupLineChartView(values: [String]) {
        xAxis.drawLabelsEnabled = false
        xAxis.setLabelCount(values.count, force: true)
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.axisLineWidth = 1.0
        xAxis.gridColor = .clear
        xAxis.axisLineColor = .clear
        xAxis.spaceMin = 0.2
        xAxis.spaceMax = 0.2
        
        rightAxis.axisLineColor = .clear
        rightAxis.axisMinimum = 0.0
        rightAxis.drawGridLinesEnabled = false
        leftAxis.axisLineWidth = 0.0
        leftAxis.gridColor = .systemGray3
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 5000
        
        extraRightOffset = 22
        extraLeftOffset = 22
        extraBottomOffset = 48
        
        legend.enabled = false
        doubleTapToZoomEnabled = false
    }
}
