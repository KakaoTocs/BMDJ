//
//  EditPopupViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/10/19.
//

import Pure
import ReactorKit

final class MemoMenuViewReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
        let repository: Repository
    }
    
    struct Payload {
        let memo: Memo
    }
    
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
    
    // MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        initialState = .init(memo: payload.memo)
    }
    
    // MARK: - Method
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .delete:
            let result = dependency.repository.memoDelete(id: currentState.memo.id)
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
        return .init(dependency: .init(repository: dependency.repository), payload: .init(memo: currentState.memo))
    }
}
