//
//  DanjiStoreService.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

final class DanjiStoreService: DanjiStoreServiceProtocol {
    
    // MARK: - Private Property
    private let danjiStore: DanjiStoreProtocol
    private let memoStore: MemoStoreProtocol
    
    // MARK: - Initialization
    init(danjiStore: DanjiStoreProtocol, memoStore: MemoStoreProtocol) {
        self.danjiStore = danjiStore
        self.memoStore = memoStore
    }
    
    // MARK: - Interface
    func danjiListRead() -> DanjiListReadResult {
        return .failure(.etc)
    }
    
    func danjiCreate() -> DanjiCreateResult {
        return .failure(.etc)
    }
    
    func danjiRead() -> DanjiReadResult {
        return .failure(.etc)
    }
    
    func danjiDelete() -> DanjiDeleteResult {
        return .failure(.etc)
    }
    
    func memoCreate() -> MemoCreateResult {
        return .failure(.etc)
    }
    
    func memoUpdate() -> MemoUpdateResult {
        return .failure(.etc)
    }
    
    func memoDelete() -> MemoDeleteResult {
        return .failure(.etc)
    }
}
