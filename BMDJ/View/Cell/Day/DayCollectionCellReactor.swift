//
//  DayCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import ReactorKit
import RxCocoa

final class DayCollectionCellReactor: Reactor {
    
    // MARK: - Define
    typealias Action = NoAction
    
    struct State {
        let day: Int
    }
    
    // MARK: - Property
    let initialState: State
    
    // MARK: - Init
    init(state: State) {
        initialState = state
    }
}
