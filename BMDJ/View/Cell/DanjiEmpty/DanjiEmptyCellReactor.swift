//
//  DanjiEmptyCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import Pure
import ReactorKit

final class DanjiEmptyCellReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
    }
    
    struct Payload {
    }
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    // MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        initialState = .init()
    }
}
