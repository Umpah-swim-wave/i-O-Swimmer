//
//  FilterTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/05.
//

import UIKit

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
        $0.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.identifier)
    }
    private var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.sectionInset = UIEdgeInsets(top: 22, left: 0, bottom: 8, right: 0)
    }
    
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
    
    @available(iOS 15.0, *)
    private func setupConfigurationButton(image: String,
                                          titlePadding: CGFloat,
                                          imagePadding: CGFloat,
                                          backgroundColor: UIColor,
                                          title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: image)
        configuration.titlePadding = titlePadding
        configuration.imagePadding = imagePadding
        configuration.baseForegroundColor = backgroundColor
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.upuhGreen, NSAttributedString.Key.font: UIFont.IBMPlexSansSemiBold(ofSize: 14)]))
        return configuration
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.identifier, for: indexPath) as? FilterCVC
        else { return UICollectionViewCell() }
        let item = indexPath.item
        
        switch sectionType {
        case .period:
            switch currentMainViewState {
            case .routine:
                break
            case .base:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "plus",
                                                                               titlePadding: 0,
                                                                               imagePadding: 4,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categoryTypes[0])
                } else {
                    cell.filterButton.setTitle(categoryTypes[0], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "plus"), for: .normal)
                }
                cell.backgroundColor = .clear
            default:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categoryTypes[item])
                } else {
                    cell.filterButton.setTitle(categoryTypes[item], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
                cell.backgroundColor = .white
            }
        case .stroke:
            switch stroke {
            case .none:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "plus",
                                                                               titlePadding: 0,
                                                                               imagePadding: 4,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokeTypes[0])
                } else {
                    cell.filterButton.setTitle(strokeTypes[0], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "plus"), for: .normal)
                }
                cell.backgroundColor = .clear
            default:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokeTypes[item])
                } else {
                    cell.filterButton.setTitle(strokeTypes[item], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
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

extension FilterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            delegate?.didClickedPeriodFilterButton()
        default:
            delegate?.didClickedStrokeFilterButton(with: 0)
        }
    }
}
