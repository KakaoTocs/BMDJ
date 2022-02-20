//
//  DanjiEmptyCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import ReactorKit

final class DanjiEmptyCellReactor: Reactor {
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState: State
    
    init() {
        initialState = .init()
    }
}
