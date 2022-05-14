//
//  DanjiLoginViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/16.
//

import Foundation

import Pure
import ReactorKit

final class LoginViewReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
        let homeViewReactor: HomeViewReactor
    }
    
    struct Payload {
        
    }
    
    enum Action {
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    let dependency: Dependency
    
    init(dependency: Dependency, payload: Payload) {
        initialState = State()
        self.dependency = dependency
    }
}
