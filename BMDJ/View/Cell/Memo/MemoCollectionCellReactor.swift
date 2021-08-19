//
//  MemoCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/02.
//

import Foundation
import ReactorKit

final class MemoCollectionCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: State
    
    struct State {
        let memoe: Memo
        let isGradient: Bool
        
        init(memo: Memo, isGradient: Bool) {
            self.memoe = memo
            self.isGradient = isGradient
        }
    }
    
    init(memo: Memo, isGradient: Bool) {
        initialState = .init(memo: memo, isGradient: isGradient)
    }
}
