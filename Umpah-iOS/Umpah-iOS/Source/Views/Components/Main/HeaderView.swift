//
//  HeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/30.
//

import UIKit

import Then
import SnapKit

class HeaderView: UIView {
    // MARK: - Properties
    var recordButton = UIButton().then {
        $0.setTitle("기록", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
    }
    var routineButton = UIButton().then {
        $0.setTitle("루틴", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
    }
    lazy var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 50, height: 2)
        flowLayout.minimumLineSpacing = 0
        $0.collectionViewLayout = flowLayout
        $0.dataSource = self
        $0.register(BottomCell.self, forCellWithReuseIdentifier: BottomCell.identifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([recordButton,
                     routineButton,
                     bottomCollectionView])
        
        recordButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        routineButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        bottomCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(1)
            $0.leading.equalTo(recordButton.snp.leading)
        }
    }
}

extension HeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCell.identifier, for: indexPath) as? BottomCell else { return UICollectionViewCell() }
        cell.backgroundColor = .black
        return cell
    }
}
