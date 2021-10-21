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
        rightAxis.labelFont = .nexaBold(ofSize: 8)
        leftAxis.axisLineWidth = 0.0
        leftAxis.gridColor = .init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 5000
        leftAxis.labelFont = .nexaBold(ofSize: 8)
        
        extraRightOffset = 22
        extraLeftOffset = 22
        extraBottomOffset = 48
        
        legend.enabled = false
        doubleTapToZoomEnabled = false
    }
}
