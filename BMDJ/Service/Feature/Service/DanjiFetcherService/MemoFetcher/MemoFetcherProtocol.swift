//
//  MemoFetcherProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/28.
//

protocol MemoFetcherProtocol {
    func fetch(_ localMemos: [Memo], _ remoteMemos: [Memo]) -> [Memo]
}
