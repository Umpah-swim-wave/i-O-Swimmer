//
//  StrokeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/11.
//

import UIKit

import SnapKit
import Then

final class StrokeView: BaseView {
    
    // MARK: - properties
    
    private lazy var strokeTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        $0.register(InsideStrokeTVC.self, forCellReuseIdentifier: InsideStrokeTVC.className)
    }
    private let strokeTypes: [String] = ["자유형", "평영", "배영", "접영", "혼영"]
    
    override func render() {
        addSubview(strokeTableView)
        
        strokeTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(310)
        }
    }
    
    override func configUI() {
        makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: 0), 7)
    }
}

// MARK: - UITableViewDataSource
extension StrokeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strokeTypes.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsideStrokeTVC.className) as? InsideStrokeTVC else { return UITableViewCell() }
        cell.setupStrokeLabel(to: strokeTypes[indexPath.row], with: indexPath.row)
        return cell
    }
}
    
// MARK: - UITableViewDelegate
extension StrokeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return StrokeHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
}
