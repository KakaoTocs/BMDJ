//
//  MemoViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/10.
//

import Foundation

import Pure
import ReactorKit

final class MemoViewReactor: Reactor, FactoryModule {
    
    struct Dependency {
        
    }
    
    struct Payload {
        let memo: Memo
    }
    
    typealias Action = NoAction
    
    let initialState: Memo
    
    init(dependency: Dependency, payload: Payload) {
        initialState = payload.memo
    }
}
