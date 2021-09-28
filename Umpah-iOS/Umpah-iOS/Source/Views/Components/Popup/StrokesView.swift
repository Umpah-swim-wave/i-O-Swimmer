//
//  StrokesView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import Then
import SnapKit

class StrokesView: UIView {
    // MARK: - Lazy Properties
    lazy var strokeTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorColor = .clear
        $0.register(StrokesTVC.self, forCellReuseIdentifier: StrokesTVC.identifier)
    }
    
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = "영법 선택"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([titleLabel, strokeTableView])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        strokeTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}

extension StrokesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StrokesTVC.identifier) as? StrokesTVC else { return UITableViewCell() }
        return cell
    }
}

extension StrokesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
