//
//  MemoStoreProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/08.
//

protocol MemoStoreProtocol {
    func create() -> MemoCreateResult
    func read() -> MemoReadResult
    func listRead() -> MemoListReadResult
    func delete() -> MemoDeleteResult
    func update() -> MemoUpdateResult
}
