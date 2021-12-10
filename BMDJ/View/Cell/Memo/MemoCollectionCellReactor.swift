//
//  MemoCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/02.
//

import Foundation
import ReactorKit

protocol MemoCollectionCellDelegate: AnyObject {
    func edit(memo: Memo)
}

final class MemoCollectionCellReactor: Reactor {
    
    enum Action {
        case edit
    }
    
    enum Mutation {
        case edit
    }

    struct State {
        let memoe: Memo
        let isGradient: Bool
        
        init(memo: Memo, isGradient: Bool) {
            self.memoe = memo
            self.isGradient = isGradient
        }
    }
    
    weak var delegate: MemoCollectionCellDelegate?
    let initialState: State
    
    init(memo: Memo, isGradient: Bool) {
        initialState = .init(memo: memo, isGradient: isGradient)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .edit:
            delegate?.edit(memo: currentState.memoe)
            return .empty()
        }
    }
}
