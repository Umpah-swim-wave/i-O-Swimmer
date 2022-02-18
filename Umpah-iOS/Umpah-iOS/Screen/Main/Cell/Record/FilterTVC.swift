//
//  FilterTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FilterTVC: UITableViewCell {
    
    private enum FilterSectionType: Int, CaseIterable {
        case period
        case stroke
    }
    
    // MARK: - properties
    
    private lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .upuhBackground
        $0.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
        $0.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.className)
    }
    private var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.sectionInset = UIEdgeInsets(top: 22, left: 0, bottom: 8, right: 0)
    }
    
    private let disposeBag = DisposeBag()
    private let categoryTypes: [String] = ["기간", "일간", "주간", "월간"]
    private let strokeTypes: [String] = ["영법", "자유형", "평영", "배영", "접영"]
    var currentMainViewState: CurrentMainViewState = .base
    var stroke: Stroke = .none
    weak var delegate: SelectedButtonDelegate?

    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        render()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        filterCollectionView.reloadData()
    }
    
    // MARK: - func
    
    private func render() {
        contentView.addSubview(filterCollectionView)
        
        filterCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
    
    private func bind() {
        filterCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard
                    let self = self,
                    let filterSectionType = FilterSectionType(rawValue: indexPath.item)
                else { return }
                
                switch filterSectionType {
                case .period:
                    self.delegate?.didClickedPeriodFilterButton()
                case .stroke:
                    self.delegate?.didClickedStrokeFilterButton(with: 0)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension FilterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentMainViewState {
        case .day, .base:
            return 1
        default:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let sectionType = FilterSectionType(rawValue: indexPath.item),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.className, for: indexPath) as? FilterCVC
        else { return UICollectionViewCell() }
        
        switch sectionType {
        case .period:
            switch currentMainViewState {
            case .routine:
                break
            case .base:
                cell.setupFilterButton(image: "plus",
                                               titlePadding: 0,
                                               imagePadding: 4,
                                               title: categoryTypes[0])
                cell.backgroundColor = .clear
            default:
                cell.setupFilterButton(image: "xmark",
                                               titlePadding: 2,
                                               imagePadding: 2,
                                               title: categoryTypes[currentMainViewState.rawValue])
                cell.backgroundColor = .white
            }
        case .stroke:
            switch stroke {
            case .none:
                cell.setupFilterButton(image: "plus",
                                       titlePadding: 0,
                                       imagePadding: 4,
                                       title: strokeTypes[0])
                cell.backgroundColor = .clear
            default:
                cell.setupFilterButton(image: "xmark",
                                       titlePadding: 2,
                                       imagePadding: 2,
                                       title: strokeTypes[stroke.rawValue])
                cell.backgroundColor = .white
            }
        }
        
        return cell
    }
}

extension FilterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionType = FilterSectionType(rawValue: indexPath.item) else { return .zero }
        
        switch (sectionType, stroke) {
        case (.stroke, .freestyle):
            return CGSize(width: 91, height: 40)
        default:
            return CGSize(width: 79, height: 40)
        }
    }
}
