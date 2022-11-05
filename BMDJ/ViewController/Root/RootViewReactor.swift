//
//  RootViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/21.
//

import Pure
import ReactorKit

final class RootViewReactor: Reactor {
    
    // MARK: - Declaration
    struct Dependency {
        let homeViewReactor: HomeViewReactor
        let loginViewReactor: LoginViewReactor
        
        let userDefaultService: UserDefaultService
    }
    
    struct Payload {
        
    }
    
    enum Action {
        case fetchToken
    }
    
    enum Mutation {
        case setToken(String?)
    }
    
    struct State {
        var token: String?
        var presentLoginVC: Void?
    }
    
    // MARK: - Property
    let initialState: State
    let dependency: Dependency
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        initialState = .init()
        self.dependency = dependency
    }
    
    // MARK: - Method
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchToken:
            let token = dependency.userDefaultService.readToken()
            return .just(.setToken(token))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setToken(let token):
            if let token = token {
                state.token = token
                state.presentLoginVC = nil
            } else {
                state.token = nil
                state.presentLoginVC = ()
            }
        }
        return state
    }
}
