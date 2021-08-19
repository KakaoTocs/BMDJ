//
//  DayCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import ReactorKit
import RxCocoa

final class DayCollectionCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: State
    
    struct State {
        let day: Int
    }
    
    init(state: State) {
        initialState = state
    }
}
