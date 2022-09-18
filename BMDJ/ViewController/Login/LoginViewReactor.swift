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
        let loginService: LoginService
    }
    
    struct Payload {
        
    }
    
    enum Action {
        case setParentViewController(UIViewController)
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
        case .setParentViewController(let viewController):
            dependency.loginService.set(parent: viewController)
            return .empty()
        case .appleLogin:
            if let token = dependency.loginService.login(service: .apple) {
                return .just(.setToken(token))
            }
            return .just(.setToken(nil))
        case .googleLogin:
            if let token = dependency.loginService.login(service: .google) {
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
