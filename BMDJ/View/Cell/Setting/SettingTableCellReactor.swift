//
//  SettingTableCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import ReactorKit
import RxCocoa

final class SettingTableCellReactor: Reactor {
    
    // MARK: - Define
    typealias Action = NoAction
    
    struct State {
        let name: String
        let value: String?
        let isSwitch: Bool
    }
    
    // MARK: - Property
    let initialState: State
    
    // MARK: - Init
    init(state: State) {
        initialState = state
    }
}
