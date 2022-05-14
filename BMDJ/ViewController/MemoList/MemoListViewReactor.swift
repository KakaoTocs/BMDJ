//
//  MemoListViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/20.
//

import Foundation

import Pure
import ReactorKit

final class MemoListViewReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
        let memoViewReactorFactory: MemoViewReactor.Factory
        let memoEditViewReactorFactory: MemoEditViewReactor.Factory
        let repository: Repository
    }
    
    struct Payload {
        let memos: [Memo]
    }
    
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
    
    // MARK: - Property
    let initialState: State
    private let disposeBag = DisposeBag()
    private let dependency: Dependency
    private let payload: Payload
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        let memoReactors = payload.memos.map { MemoCollectionCellReactor(memo: $0, isGradient: true) }
        initialState = .init(memoSections: [.init(model: (), items: memoReactors)])
        
        for memoReactor in memoReactors {
            memoReactor.delegate = self
        }
    }
    
    // MARK: - Method
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
        let memoEventMutation = dependency.repository.memoEvent
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
        return dependency.memoViewReactorFactory.create(payload: .init(memo: reactor.currentState.memoe))
    }
    
    func reactorForMemoMenu(_ memo: Memo) -> MemoMenuViewReactor {
        return .init(dependency: .init(repository: dependency.repository), payload: .init(memo: memo))
    }
}

extension MemoListViewReactor: MemoCollectionCellDelegate {
    func edit(memo: Memo) {
        Observable.just(Action.edit(memo: memo))
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
