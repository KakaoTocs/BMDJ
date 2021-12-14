//
//  PrivacyPolicyReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/01.
//

import Foundation

import ReactorKit

final class PrivacyPolicyReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
}
