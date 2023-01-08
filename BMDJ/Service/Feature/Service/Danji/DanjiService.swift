//
//  DanjiService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/02.
//

import RxSwift

final class DanjiService: DanjiServiceProtocol {
    
    private let danjiClient: DanjiClient
    private let memoService: MemoService
    
    init(danjiClient: DanjiClient, memoService: MemoService) {
        self.danjiClient = danjiClient
        self.memoService = memoService
    }
    
    func danjiListRead() -> Observable<DanjiListReadResult> {
        return .empty()
    }
    
    func danjiCreate() -> Observable<DanjiCreateResult> {
        return .empty()
    }
    
    func danjiRead() -> Observable<DanjiReadResult> {
        return .empty()
    }
    
    func danjiDelete() -> Observable<DanjiDeleteResult> {
        return .empty()
    }
    
    func danjiUpdate() -> Observable<DanjiUpdateResult> {
        return .empty()
    }
}
