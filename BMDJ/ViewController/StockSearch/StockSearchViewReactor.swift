//
//  StockSearchViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import ReactorKit
import RxDataSources

typealias StockSection = SectionModel<Void, StockCellReactor>
final class StockSearchViewReactor: Reactor {
    
    enum Action {
        case search(String?)
        case cancel
    }
    
    enum Mutation {
        case search(String?)
        case cancel
    }
    
    struct State {
        var stockSections: [StockSection] = []
    }
    
    let initialState: State
    
    init() {
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let text):
            return .just(.search(text))
        case .cancel:
            return .just(.cancel)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .search(let search):
            if let search = search {
                let stocks = StockService.shared.search(text: search).map { StockCellReactor(dependency: .init(), payload: .init(stock: $0, keyword: search)) }
                state.stockSections = [.init(model: (), items: stocks)]
            } else {
                state.stockSections = [.init(model: (), items: [])]
            }
        case .cancel:
            state.stockSections = [.init(model: (), items: [])]
        }
        return state
    }
}
