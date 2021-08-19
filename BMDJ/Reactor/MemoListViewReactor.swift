//
//  MemoListViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/20.
//

import Foundation

import ReactorKit

final class MemoListViewReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var memoSections: [MemoSection] //= []
    }
    
    let initialState: State
    
    init(memos: [Memo]) {
        let memoReactors = memos.map { MemoCollectionCellReactor(memo: $0, isGradient: true) }
        initialState = .init(memoSections: [.init(model: (), items: memoReactors)])
    }
    
    func reactorForMemoView(_ reactor: MemoCollectionCellReactor) -> MemoViewReactor {
        return MemoViewReactor(memo: reactor.currentState.memoe)
    }
}
