//
//  Extension+UICollectionView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/25.
//

import UIKit

extension UICollectionView {
    func setCollectionViewNib(nib: String) {
        let customNib = UINib(nibName: nib, bundle: nil)
        self.register(customNib, forCellWithReuseIdentifier: nib)
    }
}

