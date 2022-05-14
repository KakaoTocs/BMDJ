//
//  MemuViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/06.
//

import Foundation

import Pure
import ReactorKit

final class MenuViewReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
        let danjiAddViewReactor: DanjiAddViewReactor
        let danjiManageViewReactorFactory: DanjiSortViewReactor.Factory
        let memoAddViewReactorFactory: MemoAddViewReactor.Factory
        let settingViewReactor: SettingViewReactor
        
        let repository: Repository
    }
    
    struct Payload {
        let danjis: [Danji]
        let activeDanji: Danji?
    }
    
    typealias Action = NoAction
    
    enum Mutation {
        case close
    }
    
    struct State {
        var isClose: Bool = false
    }
    
    // MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        self.initialState = .init()
    }
    
    // MARK: - Method
    func reduce(state: State, mutation: Mutation) -> State {
        var state = self.currentState
        
        switch mutation {
        case .close:
            state.isClose = true
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let danjiEventMutation = dependency.repository.danjiEvent
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
        return dependency.danjiAddViewReactor
    }
    
    func reactorForSortDanji() -> DanjiSortViewReactor {
        return dependency.danjiManageViewReactorFactory.create(payload: .init(danjis: payload.danjis))
    }
    
    func reactorForMemoAdd() -> MemoAddViewReactor? {
        if let activeDanji = payload.activeDanji {
            return dependency.memoAddViewReactorFactory.create(payload: .init(activeDanji: activeDanji))
        }
        return nil
    }
    
    func reactorForSetting() -> SettingViewReactor {
        return dependency.settingViewReactor
    }
}
