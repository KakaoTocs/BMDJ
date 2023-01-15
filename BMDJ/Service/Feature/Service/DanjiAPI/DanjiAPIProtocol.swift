//
//  DanjiAPIProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

protocol DanjiAPIProtocol {
    func create(_ danjiCreate: DanjiCreate) -> Observable<DanjiCreateResult>
    func read(_ danjiID: String) -> Observable<DanjiReadResult>
    func delete(_ id: String) -> Observable<MemoDeleteResult>
    func sort(_ ids: [String]) -> Observable<[DanjiLite]>
    func mood(_ id: String, mood: DanjiLite.Mood) -> Observable<DanjiMoodResult>
}
