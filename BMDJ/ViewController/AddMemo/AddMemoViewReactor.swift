//
//  AddMemoViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/10.
//

import UIKit

import ReactorKit

final class AddMemoViewReactor: Reactor {
    
    enum Action {
        case updateText(String?)
        case updateMood(Danji.Mood)
        case selectImage(UIImage?)
        case save
    }
    
    enum Mutation {
        case updateText(String?)
        case updateMood(Danji.Mood)
        case updateDanjiID(String)
        case selectImage(UIImage?)
        case dismiss
    }
    
    struct State {
        var memoCreate: MemoCreate
        var dismiss: Bool = false
    }
    
    let initialState: State
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, activeDanji: Danji) {
        self.provider = provider
        
        self.initialState = .init(memoCreate: .init(mood: .happy, text: "", danjiId: activeDanji.id, image: nil))
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let danjiEventMutation = provider.repository.danjiEvent
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
            let result = provider.repository.memoAdd(memoCreate: currentState.memoCreate)
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
