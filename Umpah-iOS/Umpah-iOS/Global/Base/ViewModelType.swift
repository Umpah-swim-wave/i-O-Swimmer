//
//  ViewModelType.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/10/19.
//

import Foundation
import RxSwift
import Moya

// MARK: - ViewModelType

protocol ViewModelType {
    
  associatedtype Input
  associatedtype Output
    
  func transform(input: Input) -> Output
}
