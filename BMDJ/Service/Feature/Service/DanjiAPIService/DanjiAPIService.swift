//
//  DanjiAPIService.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

final class DanjiAPIService: DanjiAPIServiceProtocol {
    
    // MARK: - Private Property
    private let danjiAPI: DanjiAPIProtocol
    private let memoAPI: MemoAPIProtocol
    
    // MARK: - Initialization
    init(danjiAPI: DanjiAPIProtocol, memoAPI: MemoAPIProtocol) {
        self.danjiAPI = danjiAPI
        self.memoAPI = memoAPI
    }
    
    // MARK: - Interface
    func create(_ danjiCreate: DanjiCreate) -> Observable<DanjiCreateResult> {
        danjiAPI.create(danjiCreate)
    }
    
    func read(_ danjiID: String) -> Observable<DanjiReadResult> {
        danjiAPI.read(danjiID)
    }
    
    func delete(_ id: String) -> Observable<MemoDeleteResult> {
        danjiAPI.delete(id)
    }
    
    func sort(_ ids: [String]) -> Observable<[DanjiLite]> {
        danjiAPI.sort(ids)
    }
    
    func mood(_ id: String, mood: DanjiLite.Mood) -> Observable<DanjiMoodResult> {
        danjiAPI.mood(id, mood: mood)
    }
    
    func createMemo(_ memoCreate: MemoCreate) -> Observable<MemoCreateResult> {
        memoAPI.create(memoCreate)
    }
    
    func readMemos(_ danjiID: String) -> Observable<MemoReadResult> {
        memoAPI.read(danjiID)
    }
    
    func updateMemo(_ id: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult> {
        memoAPI.update(id, memoUpdate: memoUpdate)
    }
    
    func deleteMemo(_ id: String) -> Observable<MemoDeleteResult> {
        memoAPI.delete(id)
    }
}
