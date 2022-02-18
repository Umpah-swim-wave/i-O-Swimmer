//
//  ChartTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Charts
import SnapKit
import Then

final class ChartTVC: UITableViewCell {
    
    // MARK: - properties
    
    private let combineChartView = CombinedChartView()
    private let chartBackView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        $0.makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: 0), 7)
    }
    private let titleLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 12)
        $0.textColor = .upuhGray
    }
    private let dateStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    private var numbers: [Double] = [1.5, 1.3, 0.8, 1.6, 1.2, 0.6, 1.4]
    private var meters: [Int] = [2000, 3000, 4000, 4500, 3300, 1800, 2400]
    private let weeks: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .upuhBackground
        selectionStyle = .none
        render()
        setupStackView()
        setupCharts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        contentView.addSubviews([titleLabel, chartBackView])
        chartBackView.addSubviews([combineChartView, dateStackView])
        
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
            $0.bottom.equalToSuperview()
        }
        dateStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(53)
            $0.trailing.equalToSuperview().inset(45)
        }
    }
    
    private func setupStackView() {
        weeks.forEach {
            let label = UILabel()
            label.text = $0
            label.font = .nexaBold(ofSize: 8)
            label.textColor = .upuhBlack
            dateStackView.addArrangedSubview(label)
        }
    }
    
    private func setupCharts() {
        combineChartView.setupLineChartView(values: weeks)
        changeLineChartdata()
    }
    
    private func changeLineChartdata(){
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
        line1.colors = [.upuhDarkOrange]
        line1.lineWidth = 2.0
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.axisDependency = Charts.YAxis.AxisDependency.right
        line1.drawValuesEnabled = false
        
        let line2 = BarChartDataSet(entries: barChartEntry, label: "일주일")
        line2.highlightEnabled = false
        line2.colors = [.upuhSubOrange]
        line2.axisDependency = Charts.YAxis.AxisDependency.left
        line2.drawValuesEnabled = false
        
        data.barData = BarChartData(dataSet: line2)
        data.lineData = LineChartData(dataSet: line1)
        combineChartView.data = data
    }
    
    func playAnimation() {
        combineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
    }
    
    func setupTitleLabel(with state: CurrentMainViewState) {
        titleLabel.text = (state == .week) ? "WEEKLY RECORD" : "MONTHLY RECORD"
        titleLabel.addCharacterSpacing(kernValue: 2)
    }
}
