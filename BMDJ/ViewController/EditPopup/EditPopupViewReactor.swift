//
//  EditPopupViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/10/19.
//

import ReactorKit

final class EditPopupViewReactor: Reactor {
    
    enum Action {
        case delete
    }
    
    enum Mutation {
        case delete
    }
    
    struct State {
        let memo: Memo
        var dismiss = false
    }
    
    let initialState: State
    let provider: ServiceProviderType
    
    init(memo: Memo, provider: ServiceProviderType) {
        self.provider = provider
        initialState = .init(memo: memo)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .delete:
            let result = provider.repository.memoDelete(id: currentState.memo.id)
            if result {
                return .just(.delete)
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .delete:
            state.dismiss = true
        }
        return state
    }
    
    func reactorForeMemoEditView() -> MemoEditViewReactor {
        return .init(memo: currentState.memo, provider: provider)
    }
}
