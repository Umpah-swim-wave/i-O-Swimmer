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
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .upuhBackground
        $0.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
        $0.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.identifier)
    }
    var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    let categorys: [String] = ["기간", "일간", "주간", "월간"]
    let strokes: [String] = ["영법", "자유형", "평영", "배영", "접영"]
    var state: CurrentState = .base
    var stroke: Stroke = .none
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
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.upuhGreen, NSAttributedString.Key.font: UIFont.IBMPlexSansText(ofSize: 14)]))
        
        return configuration
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
            
            cell.backgroundColor = .white
            
            
            switch state {
            case .base:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "plus",
                                                                               titlePadding: 0,
                                                                               imagePadding: 4,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categorys[0])
                } else {
                    cell.filterButton.setTitle(categorys[0], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "plus"), for: .normal)
                }
                cell.backgroundColor = .clear
            case .day:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categorys[1])
                } else {
                    cell.filterButton.setTitle(categorys[1], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .week:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categorys[2])
                } else {
                    cell.filterButton.setTitle(categorys[2], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .month:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: categorys[3])
                } else {
                    cell.filterButton.setTitle(categorys[3], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .routine:
                break
            }
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVC.identifier, for: indexPath) as? FilterCVC else { return UICollectionViewCell() }
            
            cell.backgroundColor = .white
            
            switch stroke {
            case .freestyle:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokes[1])
                } else {
                    cell.filterButton.setTitle(strokes[1], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .breaststroke:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokes[2])
                } else {
                    cell.filterButton.setTitle(strokes[2], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .backstroke:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokes[3])
                } else {
                    cell.filterButton.setTitle(strokes[3], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            case .butterfly:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "xmark",
                                                                               titlePadding: 2,
                                                                               imagePadding: 2,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokes[4])
                } else {
                    cell.filterButton.setTitle(strokes[4], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "xmark"), for: .normal)
                }
            default:
                if #available(iOS 15, *) {
                    cell.filterButton.configuration = setupConfigurationButton(image: "plus",
                                                                               titlePadding: 0,
                                                                               imagePadding: 4,
                                                                               backgroundColor: .upuhGreen,
                                                                               title: strokes[0])
                } else {
                    cell.filterButton.setTitle(strokes[0], for: .normal)
                    cell.filterButton.setImage(UIImage(named: "plus"), for: .normal)
                }
                cell.backgroundColor = .clear
            }
            
            return cell
        }
    }
}

extension FilterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 1:
            switch stroke {
            case .freestyle:
                return CGSize(width: 91, height: 40)
            default:
                return CGSize(width: 79, height: 40)
            }
        default:
            return CGSize(width: 79, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
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
            delegate?.didClickedStrokeButton(indexPath: 0)
        }
    }
}
