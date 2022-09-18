//
//  DanjiSortViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/11.
//

import Foundation

import Pure
import ReactorKit
import RxDataSources

typealias DanjiSortSection = SectionModel<Void, DanjiSortTableCellReactor>

final class DanjiSortViewReactor: Reactor, FactoryModule {
    
//    MARK: - Define
    struct Dependency {
        let repository: Repository
    }
    
    struct Payload {
        let danjis: [DanjiLite]
    }
    
    enum Action {
        case move(IndexPath, IndexPath)
    }
    
    enum Mutation {
        case move(IndexPath, IndexPath)
        case dismiss
    }
    
    struct State {
        var danjiSortSections: [DanjiSortSection]
        var dismiss: Bool = false
    }
    
//    MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload
    
//    MARK: - Init
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        let danjiReactors = payload.danjis.map { DanjiSortTableCellReactor(danji: $0) }
        self.initialState = .init(danjiSortSections: [.init(model: (), items: danjiReactors)])
    }
    
//    MARK: - Method
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .move(let sourceIndexPath, let destinationIndexPath):
            let result = dependency.repository.danjiMove(index: sourceIndexPath.item, to: destinationIndexPath.item)
            if result {
                return .just(.move(sourceIndexPath, destinationIndexPath))
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .move(let sourceIndexPath, let destinationIndexPath):
            if var danjiSection = state.danjiSortSections.first {
                let danji = danjiSection.items.remove(at: sourceIndexPath.item)
                danjiSection.items.insert(danji, at: destinationIndexPath.item)
                state.danjiSortSections = [danjiSection]
            }
            print("\(sourceIndexPath.item) -> \(destinationIndexPath.item)")
        case .dismiss:
            state.dismiss = true
        }
        return state
    }
}
