//
//  ChartTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Then
import SnapKit
import Charts

class ChartTVC: UITableViewCell {
    static let identifier = "ChartTVC"
    
    // MARK: - Properties
    let lineChartView = LineChartView()
    let chartBackView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    var numbers: [Double] = [3.0, 2.5, 3.3, 5.5, 2.7, 2.8, 4.1]
    let weeks: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        initCharts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        sendSubviewToBack(contentView)
        addSubviews([chartBackView])
        chartBackView.addSubview(lineChartView)
        
        chartBackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(68)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(353)
        }

        lineChartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(105)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    private func initCharts() {
        lineChartView.setupLineChartView(values: weeks)
        lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuint)
        
        changeLineChartdata()
    }
    
    func changeLineChartdata(){
        var lineChartEntry = [ChartDataEntry]()
 
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "일주일")
        line1.highlightEnabled = false
        line1.colors = [.gray]
        line1.circleColors = [NSUIColor.gray]
        line1.circleHoleColor = NSUIColor.systemGray5
        line1.circleRadius = 4.0
        line1.circleHoleRadius = 1.5
        line1.lineWidth = 3.0
        line1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: line1)
        lineChartView.data = data
    }
}
