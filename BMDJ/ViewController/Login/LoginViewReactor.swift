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
        let appleLoginService: AppleLoginService
        let googleLoginService: GoogleLoginService
    }
    
    struct Payload {
        
    }
    
    enum Action {
        case appleLogin
        case googleLogin
    }
    
    enum Mutation {
        case setToken(String?)
    }
    
    struct State {
        var token: String?
    }
    
    let initialState: State
    let dependency: Dependency
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .default)
    
    init(dependency: Dependency, payload: Payload) {
        initialState = State()
        self.dependency = dependency
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLogin:
            if let (token, _) = dependency.appleLoginService.login() {
                return .just(.setToken(token))
            }
            return .just(.setToken(nil))
        case .googleLogin(let viewController):
            if let (token, _) = dependency.googleLoginService.login() {
                return .just(.setToken(token))
            }
            return .just(.setToken(nil))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setToken(let token):
            state.token = token
        }
        return state
    }
}
