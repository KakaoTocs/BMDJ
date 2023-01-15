//
//  DanjiStoreServiceProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

protocol DanjiStoreServiceProtocol {
    func create() -> DanjiCreateResult
    func read() -> DanjiReadResult
    func listRead() -> DanjiListReadResult
    func delete() -> DanjiDeleteResult
    func mood() -> DanjiMoodResult
    func sort() -> DanjiSortResult
    func memoCreate() -> MemoCreateResult
    func memoUpdate() -> MemoUpdateResult
    func memoDelete() -> MemoDeleteResult
}
