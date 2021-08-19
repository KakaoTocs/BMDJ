//
//  SettingTitleHeaderReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/22.
//

import Foundation

import ReactorKit

final class SettingTitleHeaderReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: String
    
    init(title: String) {
        initialState = title
    }
}
