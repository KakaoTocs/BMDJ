//
//  DanjiCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/01.
//

import ReactorKit
import RxCocoa

final class DanjiCollectionCellReactor: Reactor {
    
    let initialState: Danji
    var provider: ServiceProviderType?
    
    init(danji: Danji) {
        initialState = danji
    }
    
    enum Action {
        case setMood(Danji.Mood)
    }
    
    enum Mutation {
        case update(Danji?)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setMood(let mood):
            return provider!.danjiRepository.updateMood(id: currentState.id, mood: mood)
                .map { danji in .update(danji)}
        }
    }
    
    func reduce(state: Danji, mutation: Mutation) -> Danji {
        var state = state
        
        switch mutation {
        case .update(let danji):
            if let danji = danji {
                state.mood = danji.mood
            }
        }
        return state
    }
}
