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
        case edit(memo: Memo)
        case delete(memo: Memo)
        case update(memo: Memo)
    }
    
    enum Mutation {
        case edit(memo: Memo)
        case delete(memo: Memo)
        case update(memo: Memo)
    }
    
    struct State {
        var memoSections: [MemoSection]
        var edit: Memo?
    }
    
    let initialState: State
    private let disposeBag = DisposeBag()
    let provider: ServiceProviderType
    
    init(memos: [Memo], provider: ServiceProviderType) {
        self.provider = provider
        let memoReactors = memos.map { MemoCollectionCellReactor(memo: $0, isGradient: true) }
        initialState = .init(memoSections: [.init(model: (), items: memoReactors)])
        
        for memoReactor in memoReactors {
            memoReactor.delegate = self
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .edit(let memo):
            return .just(.edit(memo: memo))
        case .delete(let memo):
            return .just(.delete(memo: memo))
        case .update(let memo):
            return .just(.update(memo: memo))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let memoEventMutation = provider.repository.memoEvent
            .flatMap { [weak self] event -> Observable<Mutation> in
                switch event {
                case .delete(let memo):
                    return self?.mutate(action: .delete(memo: memo)) ?? .empty()
                case .update(let memo):
                    return self?.mutate(action: .update(memo: memo)) ?? .empty()
                default:
                    return .empty()
                }
            }
        return Observable.of(mutation, memoEventMutation).merge()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .edit(let memo):
            state.edit = memo
        case .delete(memo: let memo):
            if let index = state.memoSections.first?.items.firstIndex(where: { $0.currentState.memoe.id == memo.id }),
               var section = state.memoSections.first {
                section.items.remove(at: index)
                state.memoSections = [.init(model: (), items: section.items)]
            }
        case .update(let memo):
            if let index = state.memoSections.first?.items.firstIndex(where: { $0.currentState.memoe.id == memo.id }),
               var section = state.memoSections.first {
                section.items[index] = .init(memo: memo, isGradient: true)
                state.memoSections = [.init(model: (), items: section.items)]
            }
        }
        return state
    }
    
    func reactorForMemoView(_ reactor: MemoCollectionCellReactor) -> MemoViewReactor {
        return MemoViewReactor(memo: reactor.currentState.memoe)
    }
    
    func reactorForEditPopup(_ memo: Memo) -> EditPopupViewReactor {
        return .init(memo: memo, provider: provider)
    }
}

extension MemoListViewReactor: MemoCollectionCellDelegate {
    func edit(memo: Memo) {
        Observable.just(Action.edit(memo: memo))
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
