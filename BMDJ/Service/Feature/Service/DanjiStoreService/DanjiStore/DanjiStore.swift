//
//  DanjiStore.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

final class DanjiStore: DanjiStoreProtocol {
    func create() -> DanjiCreateResult {
        return .failure(.etc)
    }
    
    func read() -> DanjiReadResult {
        return .failure(.etc)
    }
    
    func delete() -> DanjiDeleteResult {
        return .failure(.etc)
    }
    
    func listRead() -> DanjiListReadResult {
        return .failure(.etc)
    }
    
    func mood() -> DanjiMoodResult {
        return .failure(.etc)
    }
    
    func sort() -> DanjiSortResult {
        return .failure(.etc)
    }
    
}
