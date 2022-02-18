//
//  StrokeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/11.
//

import UIKit

import Then
import SnapKit

class StrokeView: UIView {
    // MARK: - Properties
    lazy var strokeTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.register(InsideStrokeTVC.self, forCellReuseIdentifier: InsideStrokeTVC.identifier)
    }
    
    let strokes: [String] = ["자유형", "평영", "배영", "접영", "혼영"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeShadow(.upuhSkyBlue, 0.6, CGSize(width: 0, height: 0), 7)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(strokeTableView)
        strokeTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(310)
        }
    }
}

extension StrokeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsideStrokeTVC.identifier) as? InsideStrokeTVC else { return UITableViewCell() }
        cell.setupLabelData(stroke: strokes[indexPath.row], index: indexPath.row)
        cell.backgroundColor = .clear
        return cell
    }
}
    
extension StrokeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let strokeLabel = UILabel().then {
            $0.text = "영법"
            $0.font = .IBMPlexSansRegular(ofSize: 12)
            $0.textColor = .upuhHeaderGray
        }
        let distanceLabel = UILabel().then {
            $0.text = "거리"
            $0.font = .IBMPlexSansRegular(ofSize: 12)
            $0.textColor = .upuhHeaderGray
        }
        let speedLabel = UILabel().then {
            $0.text = "평균속도"
            $0.font = .IBMPlexSansRegular(ofSize: 12)
            $0.textColor = .upuhHeaderGray
        }
        view.addSubviews([strokeLabel, distanceLabel, speedLabel])
        strokeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(135)
        }
        speedLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(43)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
}
