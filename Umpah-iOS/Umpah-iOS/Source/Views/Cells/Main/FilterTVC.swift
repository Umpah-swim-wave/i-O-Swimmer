//
//  FilterTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

import Then
import SnapKit

class FilterTVC: UITableViewCell {
    static let identifier = "FilterTVC"
    
    // MARK: - Properties
    lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .init(red: 223/255, green: 231/255, blue: 233/255, alpha: 1.0)
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
        $0.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.identifier)
    }
    var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    let categorys: [String] = ["일간", "영법"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(filterCollectionView)
        
        filterCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
}

extension FilterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.identifier, for: indexPath) as? FilterCVC else { return UICollectionViewCell() }
        cell.filterButton.setTitle(categorys[indexPath.item], for: .normal)
        return cell
    }
}

extension FilterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 79, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 0, bottom: 8, right: 0)
    }
}
