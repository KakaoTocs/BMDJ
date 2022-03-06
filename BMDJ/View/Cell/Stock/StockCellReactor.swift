//
//  StockCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import ReactorKit

final class StockCellReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        let stock: Stock
        let keyword: String
    }
    
    let initialState: State
    
    init(stock: Stock, keyword: String) {
        initialState = .init(stock: stock, keyword: keyword)
    }
}
