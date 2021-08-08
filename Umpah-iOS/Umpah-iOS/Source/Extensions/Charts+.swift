//
//  Charts+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/08.
//

import Foundation
import Charts

extension LineChartView {
    func setupLineChartView(values: [String]) {
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .medium)
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values: values)
        xAxis.setLabelCount(values.count, force: true)
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.axisLineWidth = 1.0
        xAxis.gridColor = .clear
        xAxis.axisLineColor = .clear
        rightAxis.enabled = false
        rightAxis.drawLabelsEnabled = false
        leftAxis.axisLineWidth = 0.0
        leftAxis.gridColor = .systemGray3
        leftAxis.drawLabelsEnabled = false
        legend.enabled = false
        doubleTapToZoomEnabled = false
        extraRightOffset = 30
        extraLeftOffset = 30
        extraBottomOffset = 10
    }
}
