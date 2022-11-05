//
//  DanjiPlantViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/12.
//

import UIKit

import Pure
import ReactorKit
import RxDataSources

typealias ColorSection = SectionModel<Void, ColorCollectionCellReactor>
typealias DaySection = SectionModel<Void, DayCollectionCellReactor>

final class DanjiAddViewReactor: Reactor, FactoryModule {
    
    // MARK: - Define
    struct Dependency {
        let repository: Repository
    }
    
    struct Payload {
    }
    
    enum Action {
        case selectColor(DanjiLite.Color)
        case changeMood(DanjiLite.Mood)
        case updateDanjiName(String)
        case updateStockName(String)
        case updateStockQuantity(String)
        case selectDday(Int)
        case plant
    }
    
    enum Mutation {
        case changeMood(DanjiLite.Mood)
        case selectColor(DanjiLite.Color)
        case updateDanjiName(String)
        case updateStockName(String)
        case updateStockQuantity(String)
        case selectDday(Int)
        case dismiss
    }
    
    struct State {
        var danjiCreate = DanjiCreate()
        var canPlant: Bool = false
        var dismiss: Bool = false
        
        let colorSections: [ColorSection] = [
            ColorSection(model: (), items: [
                ColorCollectionCellReactor(state: .init(color: .red)),
                ColorCollectionCellReactor(state: .init(color: .yellow)),
                ColorCollectionCellReactor(state: .init(color: .green)),
                ColorCollectionCellReactor(state: .init(color: .blue)),
                ColorCollectionCellReactor(state: .init(color: .purple))
            ])
        ]
        
        let daySections: [DaySection] = [
            DaySection(model: (), items: [
                DayCollectionCellReactor(state: .init(day: 30)),
                DayCollectionCellReactor(state: .init(day: 100)),
                DayCollectionCellReactor(state: .init(day: 200)),
                DayCollectionCellReactor(state: .init(day: 300))
            ])
        ]
    }
    
    // MARK: - Property
    let initialState: State
    private let dependency: Dependency
    private let payload: Payload
    
    init(dependency: Dependency, payload: Payload) {
        self.dependency = dependency
        self.payload = payload
        initialState = .init()
    }
    
    // MARK: - Method
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectColor(let color):
            return .just(.selectColor(color))
        case .updateDanjiName(let name):
            return .just(.updateDanjiName(name))
        case .updateStockName(let name):
            return .just(.updateStockName(name))
        case .updateStockQuantity(let number):
            return .just(.updateStockQuantity(number))
        case .changeMood(let mood):
            return .just(.changeMood(mood))
        case .selectDday(let day):
            return .just(.selectDday(day))
        case .plant:
            let result = dependency.repository.danjiAdd(danjiCreate: currentState.danjiCreate)
            if result {
                return .just(.dismiss)
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .selectColor(let color):
            state.danjiCreate.color = color
        case .updateDanjiName(let name):
            state.danjiCreate.name = name
        case .updateStockName(let name):
            state.danjiCreate.stockName = name
        case .updateStockQuantity(let quantity):
            state.danjiCreate.volume = quantity
        case .changeMood(let mood):
            state.danjiCreate.mood = mood
        case .selectDday(let day):
            state.danjiCreate.dDay = day
            state.danjiCreate.endDate = (Int(Date().timeIntervalSince1970) + day * 86400) * 1000
        case .dismiss:
            state.dismiss = true
        }
        state.canPlant = checkCanPlant(state: state)
        return state
    }
    
    private func colorToDanjiColor(color: UIColor) -> DanjiLite.Color? {
        switch color {
        case .sub1:
            return .red
        case .sub2:
            return .yellow
        case .sub3:
            return .green
        case .sub4:
            return .blue
        case .primary:
            return .purple
        default:
            return nil
        }
    }
    
    private func checkCanPlant(state: State) -> Bool {
        return state.danjiCreate.name.isNotEmpty && state.danjiCreate.stockName.isNotEmpty && state.danjiCreate.volume.isNotEmpty
    }
}
