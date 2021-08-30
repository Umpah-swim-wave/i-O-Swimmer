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
    let weekButton = UIButton().then {
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.tintColor = .black
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.setTitle("이번 주", for: .normal)
        $0.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }
    let strokeButton = UIButton().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.setBackgroundColor(.darkGray, for: .normal)
        $0.setBackgroundColor(.gray, for: .highlighted)
        $0.tintColor = .white
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("전체", for: .normal)
        $0.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    let averageTitleLabel = UILabel().then {
        $0.text = "AVERAGE"
        $0.font = .boldSystemFont(ofSize: 8)
        $0.addCharacterSpacing(kernValue: 2)
    }
    let averageLabel = UILabel().then {
        $0.text = "2.1km"
        $0.font = .boldSystemFont(ofSize: 24)
        $0.addCharacterSpacing(kernValue: 2)
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
        
        addSubviews([chartBackView, weekButton])
        chartBackView.addSubviews([lineChartView, strokeButton, averageTitleLabel, averageLabel])
        
        chartBackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(68)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(353)
        }
        
        weekButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(26)
            $0.height.equalTo(28)
            $0.width.equalTo(82)
        }

        lineChartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(105)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22)
        }
        
        strokeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(24)
            $0.width.equalTo(55)
        }
        
        averageTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(30)
        }
        
        averageLabel.snp.makeConstraints {
            $0.top.equalTo(averageTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(averageTitleLabel.snp.leading)
        }
    }
    
    func initCharts() {
        lineChartView.setupLineChartView(values: weeks)
        
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