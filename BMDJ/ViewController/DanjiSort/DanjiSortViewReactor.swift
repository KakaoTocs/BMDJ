//
//  DanjiSortViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/11.
//

import Foundation

import ReactorKit
import RxDataSources

typealias DanjiSortSection = SectionModel<Void, DanjiSortTableCellReactor>

final class DanjiSortViewReactor: Reactor {
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
    
    let initialState: State
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType, danjis: [Danji]) {
        self.provider = provider
        let danjiReactors = danjis.map { DanjiSortTableCellReactor(danji: $0) }
        self.initialState = State(danjiSortSections: [.init(model: (), items: danjiReactors)])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .move(let sourceIndexPath, let destinationIndexPath):
            let result = provider.repository.danjiMove(index: sourceIndexPath.item, to: destinationIndexPath.item)
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
