//
//  SwimmingStorage.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/09/28.
//

import Foundation
import RxSwift

protocol SwimmingStorageType {
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}

