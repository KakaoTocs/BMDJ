//
//  MemoStore.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

final class MemoStore: MemoStoreProtocol {
    func create() -> MemoCreateResult {
        return .failure(.etc)
    }
    
    func read() -> MemoReadResult {
        return .failure(.etc)
    }
    
    func listRead() -> MemoListReadResult {
        return .failure(.etc)
    }
    
    func delete() -> MemoDeleteResult {
        return .failure(.etc)
    }
    
    func update() -> MemoUpdateResult {
        return .failure(.etc)
    }
}
