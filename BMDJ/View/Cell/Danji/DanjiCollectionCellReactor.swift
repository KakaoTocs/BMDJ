//
//  DanjiCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/01.
//

import ReactorKit
import RxCocoa

final class DanjiCollectionCellReactor: Reactor {
    
    let initialState: State
    var provider: ServiceProviderType?
    
    init(danji: Danji) {
        let name = StockService.shared.getName(form: danji.stock.name) ?? danji.stock.name
        initialState = .init(danji: danji, id: danji.id, isHappy: danji.isHappy, mood: danji.mood, dDayString: danji.dDayString, nickName: danji.name, stockName: danji.stock.name, volume: danji.volume, danjiImage: danji.danjiImage, landImage: danji.landImage, moodColor: danji.mood == .happy ? .font1 : .white)
    }
    
    enum Action {
        case setMood(Danji.Mood)
    }
    
    enum Mutation {
        case update(Danji?)
    }
    
    struct State {
        let danji: Danji
        let id: String
        let isHappy: Bool
        let mood: Danji.Mood
        let dDayString: String
        let nickName: String?
        let stockName: String?
        let volume: String
        let danjiImage: UIImage?
        let landImage: UIImage?
        let moodColor: UIColor
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
