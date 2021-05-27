//
//  HomeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/10.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    private let mainHeaderView = HomeMainHeaderView()
    private let routeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        linkCollectionViewCell()
    }
    
    private func setupConfigure() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        routeCollectionView.collectionViewLayout = flowLayout
        routeCollectionView.delegate = self
        routeCollectionView.dataSource = self
        routeCollectionView.backgroundColor = .none?.withAlphaComponent(0)
        
        view.addSubview(mainHeaderView)
        view.addSubview(routeCollectionView)
        mainHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(128)
        }
        routeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func linkCollectionViewCell() {
        routeCollectionView.setCollectionViewNib(nib: HomeTodayRouteCVC.identifier)
        routeCollectionView.setCollectionViewNib(nib: HomeSelectRouteCVC.identifier)
        routeCollectionView.register(HomeSelectRouteHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSelectRouteHeaderView.identifier)
    }
}

extension HomeVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTodayRouteCVC.identifier, for: indexPath) as? HomeTodayRouteCVC else {
                return UICollectionViewCell()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSelectRouteCVC.identifier, for: indexPath) as? HomeSelectRouteCVC else {
                return UICollectionViewCell()
            }
            return cell
        default: break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSelectRouteHeaderView.identifier, for: indexPath) as? HomeSelectRouteHeaderView else {
                    return UICollectionReusableView()
                }
                return headerView
            default:
                assert(false, "Fail to create header")
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionHeadersPinToVisibleBounds = true
            }
            return CGSize(width: UIScreen.main.bounds.size.width, height: 30)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let dvc = storyboard?.instantiateViewController(withIdentifier: "DetailedRoutineVC") as? DetailedRoutineVC else { return }
            dvc.modalPresentationStyle = .overCurrentContext
            present(dvc, animated: true, completion: nil)
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch section {
        case 0:
            width = UIScreen.main.bounds.size.width - 32
            height = (width * 188) / 343
        case 1:
            width = UIScreen.main.bounds.size.width - 32
            height = (width * 89) / 343
        default: break
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 48, right: 16)
    }
}
