//
//  SettingTableCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import ReactorKit
import RxCocoa

final class SettingTableCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: State
    
    struct State {
        let name: String
        let value: String?
        let isSwitch: Bool
    }
    
    init(state: State) {
        initialState = state
    }
}
