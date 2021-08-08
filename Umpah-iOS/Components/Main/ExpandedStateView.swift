//
//  ExpandedStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit
import Charts

class ExpandedStateView: UIView {
    // MARK: - Properties
    lazy var typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.identifier)
    }
    let titleLabel = UILabel().then {
        $0.text = "MY PROGRESS"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
    }
    let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 16
    }
    let lineChartView = LineChartView()
    let chartBackView = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 16
    }
    
    let types: [String] = ["DAY", "WEEK", "MONTH", "ALL"]
    var numbers: [Double] = [3.0, 2.5, 3.3, 5.5, 2.7, 2.8, 4.1]
    let weeks: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

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
        addSubviews([titleLabel, typeCollectionView, chartBackView])
        chartBackView.addSubview(lineChartView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(46)
            $0.leading.equalToSuperview().inset(32)
        }
        
        typeCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(312)
        }
        
        chartBackView.snp.makeConstraints {
            $0.top.equalTo(typeCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
        
        lineChartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func initCharts() {
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

extension ExpandedStateView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCell.identifier, for: indexPath) as? TypeCell else { return UICollectionViewCell() }
        cell.typeLabel.text = types[indexPath.item]
        cell.typeLabel.addCharacterSpacing(kernValue: 2)
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else  {
            cell.isSelected = false
        }
        
        return cell
    }
}

extension ExpandedStateView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateLabelWidth(text: types[indexPath.item])
        return CGSize(width: width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func calculateLabelWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 12)
        label.addCharacterSpacing(kernValue: 2)
        label.sizeToFit()
        
        return label.bounds.size.width + 28
    }
}
