//
//  MemoAPIProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

protocol MemoAPIProtocol {
    func create(_ memoCreate: MemoCreate) -> Observable<MemoCreateResult>
    func read(_ danjiID: String) -> Observable<MemoReadResult>
    func update(_ id: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult>
    func delete(_ id: String) -> Observable<MemoDeleteResult>
}
