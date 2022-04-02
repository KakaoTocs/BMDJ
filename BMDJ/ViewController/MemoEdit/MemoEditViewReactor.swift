//
//  MemoEditViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/11/10.
//

import Foundation

import ReactorKit
import RxDataSources

final class MemoEditViewReactor: Reactor {
    enum Action {
        case edit(String)
    }
    
    enum Mutation {
        case dismiss
    }
    
    struct State {
        let memo: Memo
        var isDismiss: Bool = false
    }
    
    let initialState: State
    let provider: ServiceProviderType
    
    init(memo: Memo, provider: ServiceProviderType) {
        self.provider = provider
        initialState = .init(memo: memo)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .edit(let text):
            let memo = currentState.memo
            let newMemo = Memo(id: memo.id, danjiID: memo.danjiID, mood: memo.mood, imageURLString: memo.imageURLString, text: text, createDate: memo.createDate, updateDate: Int(Date().timeIntervalSince1970 * 1000))
            let result = provider.repository.memoUpdate(id: newMemo.id, text: newMemo.text)
            if result {
                return .just(.dismiss)
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            state.isDismiss = true
        }
        return state
    }
}
