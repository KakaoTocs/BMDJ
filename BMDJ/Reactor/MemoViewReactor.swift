//
//  MemoViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/10.
//

import Foundation

import ReactorKit

final class MemoViewReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: Memo
    
    init(memo: Memo) {
        initialState = memo
    }
}
