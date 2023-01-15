//
//  MemoAPI.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

final class MemoAPI: MemoAPIProtocol {
    func create(_ memoCreate: MemoCreate) -> Observable<MemoCreateResult> {
        return .empty()
    }
    
    func read(_ danjiID: String) -> Observable<MemoReadResult> {
        return .empty()
    }
    
    func update(_ id: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult> {
        return .empty()
    }
    
    func delete(_ id: String) -> Observable<MemoDeleteResult> {
        return .empty()
    }
}
