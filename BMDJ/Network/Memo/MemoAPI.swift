//
//  MemoAPI.swift
//  BMDJ
//
//  Created by 김진우 on 2022/08/15.
//

import RxSwift

typealias MemoAllResult = Result<[Memo], BDError>
typealias MemoRemoveResult = Result<Bool, BDError>
typealias MemoAddResult = Result<Memo, BDError>
typealias MemoUpdateResult = Result<Bool, BDError>

protocol MemoAPI {
    func all(_ danjiID: String) -> Observable<MemoAllResult>
    func remove(_ danjiID: String) -> Observable<MemoRemoveResult>
    func add(_ memoCreate: MemoCreate) -> Observable<MemoAddResult>
    func update(_ danjiID: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult>
}
