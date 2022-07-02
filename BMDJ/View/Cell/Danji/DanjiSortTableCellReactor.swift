//
//  DanjiSortTableCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import ReactorKit
import RxCocoa

final class DanjiSortTableCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: DanjiLite
    
    init(danji: DanjiLite) {
        initialState = danji
    }
}
