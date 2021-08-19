//
//  ColorCollectionCellReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import UIKit

import ReactorKit
import RxCocoa

final class ColorCollectionCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: State
    
    struct State {
        let color: Danji.Color
    }
    
    init(state: State) {
        initialState = state
    }
}
