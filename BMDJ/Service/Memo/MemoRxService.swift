//
//  MemoRxService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/09/18.
//

import Foundation

import RxSwift

final class MemoRxService {
    
    // MARK: - Property
    private let memoAPI: MemoAPI
    
    // MARK: - Init
    init(memoAPI: MemoAPI) {
        self.memoAPI = memoAPI
    }
    
    // MARK: - Interface
    public func all(_ danjiID: String) -> Observable<MemoAllResult> {
        return memoAPI.all(danjiID)
    }
    
    public func remove(_ danjiID: String) -> Observable<MemoRemoveResult> {
        return memoAPI.remove(danjiID)
    }
    
    public func add(_ memoCreate: MemoCreate) -> Observable<MemoAddResult> {
        return memoAPI.add(memoCreate)
    }
    
    public func update(_ danjiID: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult> {
        return memoAPI.update(danjiID, memoUpdate: memoUpdate)
    }
}
