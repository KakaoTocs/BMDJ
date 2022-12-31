//
//  MemoAPI.swift
//  BMDJ
//
//  Created by 김진우 on 2022/08/15.
//

import RxSwift

typealias MemoCreateResult = Result<Memo, BDError>
typealias MemoReadResult = Result<[Memo], BDError>
typealias MemoUpdateResult = Result<EmptyEntity, BDError>
typealias MemoDeleteResult = Result<EmptyEntity, BDError>

protocol MemoAPI {
    func create(_ memoCreate: MemoCreate) -> Observable<MemoCreateResult>
    func read(_ danjiID: String) -> Observable<MemoReadResult>
    func update(_ id: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult>
    func delete(_ id: String) -> Observable<MemoDeleteResult>
}
