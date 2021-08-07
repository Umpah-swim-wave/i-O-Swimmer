//
//  NormalStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit
import Charts

class NormalStateView: UIView {
    // MARK: - Properties
    var lineChartView = LineChartView()
    let chartBackView = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 16
    }
    let titleLabel = UILabel().then {
        $0.text = "TOTAL"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
    }
    let kilometerLabel = UILabel().then {
        $0.text = "13.7 km"
        $0.font = .boldSystemFont(ofSize: 24)
    }
    
    var numbers: [Double] = [3.0, 2.5, 3.3, 5.5, 2.7]
    let swimPositions: [String] = ["자유형", "평영", "배영", "접영", "혼영"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        initCharts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        addSubviews([titleLabel, kilometerLabel, chartBackView])
        chartBackView.addSubview(lineChartView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46)
            $0.leading.equalToSuperview().inset(32)
        }
        
        kilometerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(32)
        }
        
        chartBackView.snp.makeConstraints {
            $0.top.equalTo(kilometerLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo((UIScreen.main.bounds.size.height * 0.42) * 0.65)
        }
        
        lineChartView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func initCharts() {
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: swimPositions)
        lineChartView.xAxis.setLabelCount(swimPositions.count, force: true)
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.xAxis.axisLineWidth = 1.0
        lineChartView.xAxis.gridColor = .clear
        lineChartView.xAxis.axisLineColor = .clear
        lineChartView.rightAxis.enabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.axisLineWidth = 0.0
        lineChartView.leftAxis.gridColor = .systemGray3
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        lineChartView.extraRightOffset = 30
        lineChartView.extraLeftOffset = 30
        lineChartView.extraBottomOffset = 10
        
        changeLineChartdata()
    }
    
    func changeLineChartdata(){
        var lineChartEntry = [ChartDataEntry]()
 
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "수영거리")
        line1.highlightEnabled = false
        line1.colors = [.gray]
        line1.circleColors = [NSUIColor.gray]
        line1.circleHoleColor = NSUIColor.systemGray5
        line1.circleRadius = 4.0
        line1.circleHoleRadius = 2.0
        line1.lineWidth = 3.0
        line1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: line1)
        lineChartView.data = data
    }
}
