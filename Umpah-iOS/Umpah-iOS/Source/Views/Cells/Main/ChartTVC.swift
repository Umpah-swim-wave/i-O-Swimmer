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
    let combineChartView = CombinedChartView()
    
    let chartBackView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    let titleLabel = UILabel().then {
        $0.text = "WEEKLY RECORD"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    var numbers: [Double] = [1.5, 1.3, 0.8, 1.6, 1.2, 0.6, 1.4]
    var meters: [Int] = [2000, 3000, 4000, 4500, 3300, 1800, 2400]
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
        
        addSubviews([titleLabel, chartBackView])
        chartBackView.addSubviews([combineChartView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
        }
        
        chartBackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(280)
        }

        combineChartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    func initCharts() {
        combineChartView.setupLineChartView(values: weeks)
        
        changeLineChartdata()
    }
    
    func changeLineChartdata(){
        let data: CombinedChartData = CombinedChartData()
        var lineChartEntry = [ChartDataEntry]()
        var barChartEntry = [BarChartDataEntry]()
 
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            let meterValue = BarChartDataEntry(x: Double(i), y: Double(meters[i]))
            lineChartEntry.append(value)
            barChartEntry.append(meterValue)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "일주일")
        line1.highlightEnabled = false
        line1.colors = [.systemOrange]
        line1.lineWidth = 2.0
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.axisDependency = Charts.YAxis.AxisDependency.right
        line1.drawValuesEnabled = false
        
        let line2 = BarChartDataSet(entries: barChartEntry, label: "일주일")
        line2.highlightEnabled = false
        line2.colors = [.systemOrange.withAlphaComponent(0.5)]
        line2.axisDependency = Charts.YAxis.AxisDependency.left
        line2.drawValuesEnabled = false
        
        data.barData = BarChartData(dataSet: line2)
        data.lineData = LineChartData(dataSet: line1)
        combineChartView.data = data
    }
}
