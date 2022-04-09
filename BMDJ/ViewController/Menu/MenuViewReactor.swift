//
//  MemuViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/06.
//

import Foundation

import ReactorKit

final class MenuViewReactor: Reactor {
    typealias Action = NoAction
    
    enum Mutation {
        case close
    }
    
    struct State {
        var isClose: Bool = false
    }
    
    let initialState: State
    let danjis: [Danji]
    let activeDanji: Danji?
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType, danjis: [Danji], activeDanji: Danji?) {
        self.provider = provider
        self.danjis = danjis
        self.activeDanji = activeDanji
        self.initialState = State()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = self.currentState
        
        switch mutation {
        case .close:
            print("Close 3")
            state.isClose = true
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let danjiEventMutation = provider.repository.danjiEvent
            .flatMap { [weak self] event -> Observable<Mutation> in
                return self?.mutate(danjiEvent: event) ?? .empty()
            }
        
        return Observable.of(mutation, danjiEventMutation).merge()
    }
    
    func mutate(danjiEvent: DanjiEvent) -> Observable<Mutation> {
        switch danjiEvent {
        case .add:
            return .just(.close)
        default:
            return .empty()
        }
    }
    
    // Reactor Export
    func reactorForPlantDanji() -> DanjiAddViewReactor {
        return DanjiAddViewReactor(provider: provider)
    }
    
    func reactorForSortDanji() -> DanjiSortViewReactor {
        return DanjiSortViewReactor(provider: provider, danjis: danjis)
    }
    
    func reactorForMemoAdd() -> MemoAddViewReactor? {
        if let danji = activeDanji {
            return MemoAddViewReactor(provider: provider, activeDanji: danji)
        }
        return nil
    }
    
    func reactorForSettingDanji() -> DanjiSettingViewReactor {
        return DanjiSettingViewReactor()
    }
}
