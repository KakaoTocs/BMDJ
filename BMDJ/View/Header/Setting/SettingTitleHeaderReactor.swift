//
//  SettingTitleHeaderReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/22.
//

import Foundation

import Pure
import ReactorKit

final class SettingTitleHeaderReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
    }
    
    struct Payload {
        let title: String
    }
    
    typealias Action = NoAction
    
    // MARK: - Property
    let initialState: String
    private let dependency: Dependency
    private let payload: Payload
    
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        initialState = .init()
    }
}
