//
//  DanjiStoreProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

protocol DanjiStoreProtocol {
    func create() -> DanjiCreateResult
    func read() -> DanjiReadResult
    func delete() -> DanjiDeleteResult
    func listRead() -> DanjiListReadResult
    func mood() -> DanjiMoodResult
    func sort() -> DanjiSortResult
}
