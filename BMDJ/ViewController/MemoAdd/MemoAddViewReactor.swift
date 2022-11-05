//
//  AddMemoViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/10.
//

import UIKit

import Pure
import ReactorKit

final class MemoAddViewReactor: Reactor, FactoryModule {
    
//    MARK: - Define
    struct Dependency {
        let repository: Repository
    }
    
    struct Payload {
        let activeDanji: DanjiLite
    }
    
    enum Action {
        case updateText(String?)
        case updateMood(DanjiLite.Mood)
        case selectImage(UIImage?)
        case save
    }
    
    enum Mutation {
        case updateText(String?)
        case updateMood(DanjiLite.Mood)
        case updateDanjiID(String)
        case selectImage(UIImage?)
        case dismiss
    }
    
    struct State {
        var memoCreate: MemoCreate
        var dismiss: Bool = false
    }
    
//    MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload

//    MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        
        self.initialState = .init(memoCreate: .init(mood: .happy, text: "", danjiId: payload.activeDanji.id, image: nil))
    }
    
//    MARK: - Method
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let danjiEventMutation = dependency.repository.danjiEvent
            .flatMap { [weak self] event -> Observable<Mutation> in
                self?.mutate(danjiEvent: event) ?? .empty()
            }
        return Observable.of(mutation, danjiEventMutation).merge()
    }
    
    func mutate(danjiEvent: DanjiEvent) -> Observable<Mutation> {
        switch danjiEvent {
        case let .update(id, danji):
            if currentState.memoCreate.danjiId == id {
                return .just(.updateDanjiID(danji.id))
            }
            return .empty()
        default:
            return .empty()
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateMood(let mood):
            return .just(.updateMood(mood))
        case .updateText(let text):
            return .just(.updateText(text))
        case .selectImage(let image):
            return .just(.selectImage(image))
        case .save:
            let result = dependency.repository.memoAdd(memoCreate: currentState.memoCreate)
            if result {
                return .just(.dismiss)
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateText(let text):
            state.memoCreate.text = text ?? ""
        case .selectImage(let image):
            state.memoCreate.image = image
        case .updateDanjiID(let id):
            state.memoCreate.danjiId = id
        case .dismiss:
            state.dismiss = true
        case .updateMood(let mood):
            state.memoCreate.mood = mood
        }
        return state
    }
}
