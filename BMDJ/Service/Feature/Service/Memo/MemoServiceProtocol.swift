//
//  MemoServiceProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

protocol MemoServiceProtocol {
    func memoListRead() -> Observable<MemoListReadResult>
    func memoiCreate() -> Observable<MemoCreateResult>
    func memoRead() -> Observable<MemoReadResult>
    func memoDelete() -> Observable<MemoDeleteResult>
    func memoUpdate() -> Observable<MemoUpdateResult>
}
