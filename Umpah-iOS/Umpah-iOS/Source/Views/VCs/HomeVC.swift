//
//  HomeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/10.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    let mainHeaderView = HomeMainHeaderView()
    let routeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }
    
    private func setupConfigure() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        routeCollectionView.collectionViewLayout = flowLayout
        routeCollectionView.delegate = self
        routeCollectionView.dataSource = self
        routeCollectionView.backgroundColor = .cyan
        
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
        return UICollectionViewCell()
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
        return UIEdgeInsets(top: 10, left: 16, bottom: 59, right: 16)
    }
}
