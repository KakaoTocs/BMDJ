//
//  GuideViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/16.
//

import ReactorKit

final class GuideViewReactor: Reactor {
    
    enum Action {
        case scrollPoint(CGFloat)
        case start
    }
    
    enum Mutation {
        case scrollPoint(CGFloat)
        case close
    }
    
    struct State {
        var backgroundColor: [CGColor] = [UIColor.init(hex: 0xFFFBEF).cgColor, UIColor.init(hex: 0xE1E5FF).cgColor]
        var nextButtonColor: UIColor = .font1
        var pointIndex = 0
        var currentIndex = 0
    }
    
    let initialState: State
    
    init() {
        initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .scrollPoint(let point):
            return .just(.scrollPoint(point))
        case .start:
            return .just(.close)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = self.currentState
        
        switch mutation {
        case .scrollPoint(let point):
            let backgroundIndex = Int(point.rounded())
            if backgroundIndex == 0 {
                state.backgroundColor = [UIColor.init(hex: 0xFFFBEF).cgColor, UIColor.init(hex: 0xE1E5FF).cgColor]
                state.currentIndex = 0
                state.pointIndex = 0
                state.nextButtonColor = .font1
            } else if backgroundIndex == 1 {
                state.backgroundColor = [UIColor.background4Gradarion1.cgColor, UIColor.background4Gradarion2.cgColor]
                state.currentIndex = 1
                state.pointIndex = 1
                state.nextButtonColor = .white
            } else {
                state.backgroundColor = [UIColor.background3Gradarion1.cgColor, UIColor.background3Gradarion2.cgColor]
                state.pointIndex = 2
            }
            print(point)
            if Int(point) >= 2 {
                state.currentIndex = 2
            }
        case .close:
            state.currentIndex = 0
        }
        return state
    }
}
