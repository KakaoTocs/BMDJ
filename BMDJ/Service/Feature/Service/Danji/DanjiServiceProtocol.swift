//
//  DanjiServiceProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

import RxSwift

protocol DanjiServiceProtocol {
    func danjiListRead() -> Observable<DanjiListReadResult>
    func danjiCreate() -> Observable<DanjiCreateResult>
    func danjiRead() -> Observable<DanjiReadResult>
    func danjiDelete() -> Observable<DanjiDeleteResult>
    func danjiUpdate() -> Observable<DanjiUpdateResult>
}
