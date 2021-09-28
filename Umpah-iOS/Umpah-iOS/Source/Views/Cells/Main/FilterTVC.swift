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
    
    let categorys: [String] = ["기간", "일간", "주간", "월간"]
    let strokes: [String] = ["영법", "자유형", "평영", "배영", "접영"]
    var state: CurrentState = .base
    var delegate: SelectedRangeDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        filterCollectionView.reloadData()
    }
    
    fileprivate func setupLayout() {
        sendSubviewToBack(contentView)
        addSubview(filterCollectionView)
        
        filterCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
}

extension FilterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .day, .base:
            return 1
        default:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.identifier, for: indexPath) as? FilterCVC else { return UICollectionViewCell() }
            
            print(state)
            switch state {
            case .base:
                cell.filterButton.setTitle(categorys[0], for: .normal)
                cell.filterButton.setImage(UIImage(systemName: "plus"), for: .normal)
                cell.backgroundColor = .clear
            case .day:
                cell.filterButton.setTitle(categorys[1], for: .normal)
                cell.filterButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.backgroundColor = .white
            case .week:
                cell.filterButton.setTitle(categorys[2], for: .normal)
                cell.filterButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.backgroundColor = .white
            case .month:
                cell.filterButton.setTitle(categorys[3], for: .normal)
                cell.filterButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.backgroundColor = .white
            case .routine:
                break
            }
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.identifier, for: indexPath) as? FilterCVC else { return UICollectionViewCell() }
            cell.filterButton.setTitle(strokes[indexPath.item], for: .normal)
            return cell
        }
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

extension FilterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            delegate?.didClickedRangeButton()
        default:
            delegate?.didClickedRangeButton()
        }
    }
}
