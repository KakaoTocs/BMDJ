//
//  DanjiAPI.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

final class DanjiAPI: DanjiAPIProtocol {
    func create(_ danjiCreate: DanjiCreate) -> Observable<DanjiCreateResult> {
        return .empty()
    }
    
    func read(_ danjiID: String) -> Observable<DanjiReadResult> {
        return .empty()
    }
    
    func delete(_ id: String) -> Observable<MemoDeleteResult> {
        return .empty()
    }
    
    func sort(_ ids: [String]) -> Observable<[DanjiLite]> {
        return .empty()
    }
    
    func mood(_ id: String, mood: DanjiLite.Mood) -> Observable<DanjiMoodResult> {
        return .empty()
    }
    
}
