//
//  StockCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import Pure
import ReactorKit

final class StockCellReactor: Reactor, Module {
    
    // MARK: - Define
    struct Dependency {
        
    }
    
    struct Payload {
        let stock: Stock
        let keyword: String
    }
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        let stock: Stock
        let keyword: String
    }
    
    // MARK: - Property
    let initialState: State
    
    // MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        initialState = .init(stock: payload.stock, keyword: payload.keyword)
    }
}
