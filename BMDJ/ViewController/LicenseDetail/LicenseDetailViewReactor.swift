//
//  LicenseDetailViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/09/05.
//

import Foundation

import ReactorKit

final class LicenseDetailViewReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        let text: String
    }
    
    let initialState: State
    
    init(text: String) {
        self.initialState = .init(text: text)
    }
}
