//
//  HomeViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

import ReactorKit
import RxDataSources
import RxOptional

typealias DanjiSection = SectionModel<Void, DanjiCollectionCellReactor>
typealias MemoSection = SectionModel<Void, MemoCollectionCellReactor>

final class HomeViewReactor: Reactor {
    
    enum Action {
        case refresh
        case activeDanjiIndex(Int)
        case refreshMemo
    }
    
    enum Mutation {
        case fetchDanjiSections([DanjiSection])
        case fetchMemoSections([MemoSection])
        case activeDanjiIndex(Int, Danji, [MemoSection])
        case removeEmpty
        case insertDanjiSectionItem(IndexPath, DanjiSection.Item)
        case updateDanjiSectionItem(IndexPath, DanjiSection.Item)
        case insertMemoSectionItem(IndexPath, MemoSection.Item)
        case updateMemoSectionItem(IndexPath, MemoSection.Item)
    }
    
    struct State {
        var backgroundGradients: [UIColor] = [.background3Gradarion1, .background3Gradarion2]
        var danjiSections: [DanjiSection]
        var memoSections: [MemoSection]
        var activeDanji: Danji?
        var activeIndex: Int?
        var isPreviousActive: Bool = false
        var isNextActive: Bool = false
    }
    
    let provider: ServiceProviderType
    let initialState: State
    let disposedBag = DisposeBag()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        initialState = .init(danjiSections: [.init(model: (), items: [])], memoSections: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.danjiRepository.fetchDanjis()
                .map { danjis in
                    let sectionItems = danjis.map(DanjiCollectionCellReactor.init)
                    var section: [DanjiSection] = []
                    if sectionItems.isEmpty {
                        section = [DanjiSection(model: (), items: [DanjiCollectionCellReactor(danji: .empty)])]
                    } else {
                        section = [DanjiSection(model: (), items: sectionItems)]
                    }
                    return .fetchDanjiSections(section)
                }
        case .activeDanjiIndex(let index):
            if let danji = currentState.danjiSections.first?.items[index].currentState {
                return provider.memoRepository.fetchMemo()
                    .map { $0.filter { $0.danjiID == danji.id }}
                    .map { memos in
                        let sectionItems = memos.map { MemoCollectionCellReactor(memo: $0, isGradient: false) }
                        var section: [MemoSection] = []
                        if sectionItems.isEmpty {
                            let mockMemo = Memo.empty(danjiID: self.currentState.activeDanji?.id ?? "nil")
                            section = [MemoSection(model: (), items: [.init(memo: mockMemo, isGradient: false)])]
                        } else {
                            section = [MemoSection(model: (), items: sectionItems)]
                        }
//                        let section = MemoSection(model: (), items: sectionItems)
                        return .activeDanjiIndex(index, danji, section)
                    }
            }
            return .just(.removeEmpty)
        case .refreshMemo:
            return provider.memoRepository.fetchMemo()
                .map { $0.filter { $0.danjiID == self.currentState.activeDanji?.id }}
                .map { memos in
                    var sectionItems: [MemoCollectionCellReactor] = []
                    if memos.isEmpty {
                        let mockMemo = Memo.empty(danjiID: self.currentState.activeDanji?.id ?? "nil")
                        sectionItems = [.init(memo: mockMemo, isGradient: false)]
                    } else {
                        sectionItems = memos.map { MemoCollectionCellReactor(memo: $0, isGradient: false) }
                    }
                    let section = MemoSection(model: (), items: sectionItems)
                    return .fetchMemoSections([section])
                }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let danjiEventMutation = provider.danjiRepository.event
            .flatMap { [weak self] event -> Observable<Mutation> in
                self?.mutate(danjiEvent: event) ?? .empty()
            }
        
        let memoEventMutation = provider.memoRepository.event
            .flatMap { [weak self] event -> Observable<Mutation> in
                self?.mutate(memoEvent: event) ?? .empty()
            }
        let memoEvent2Mutation = provider.danjiRepository.event
            .flatMap { [weak self] event -> Observable<Mutation> in
                switch event {
                case .create, .move, .refresh:
                    return self?.mutate(action: .refreshMemo) ?? .empty()
                default:
                    return .empty()
                }
            }
        return Observable.of(mutation, danjiEventMutation, memoEvent2Mutation, memoEventMutation).merge()
    }
    
    func mutate(danjiEvent: DanjiEvent) -> Observable<Mutation> {
        let state = self.currentState
        
        switch danjiEvent {
        case let .add(danji), let .create(danji):
          let indexPath = IndexPath(item: 0, section: 0)
            let reactor = DanjiCollectionCellReactor(danji: danji)
          return .just(.insertDanjiSectionItem(indexPath, reactor))

        case let .update(danji):
          guard let indexPath = self.danjiIndexPath(forDanjiID: danji.id, from: state) else { return .empty() }
            let reactor = DanjiCollectionCellReactor(danji: danji)
          return .just(.updateDanjiSectionItem(indexPath, reactor))
        case .move:
            return provider.danjiRepository.fetchDanjis()
                .map { danjis in
                    let sectionItems = danjis.map(DanjiCollectionCellReactor.init)
                    let section = DanjiSection(model: (), items: sectionItems)
                    return .fetchDanjiSections([section])
                }
        case .refresh:
            return .just(.removeEmpty)
        }
    }
    
    
    func mutate(memoEvent: MemoEvent) -> Observable<Mutation> {
        let state = self.currentState
        
        switch memoEvent {
        case let .add(memo), let .create(memo):
          let indexPath = IndexPath(item: 0, section: 0)
          let reactor = MemoCollectionCellReactor(memo: memo, isGradient: false)
          return .just(.insertMemoSectionItem(indexPath, reactor))

        case let .update(memo):
          guard let indexPath = self.memoIndexPath(forMemoID: memo.id, from: state) else { return .empty() }
          let reactor = MemoCollectionCellReactor(memo: memo, isGradient: false)
          return .just(.updateMemoSectionItem(indexPath, reactor))
        case .move:
            return provider.memoRepository.fetchMemo()
                .map { memos in
                    let sectionItems = memos.map { MemoCollectionCellReactor(memo: $0, isGradient: false) }
                    let section = MemoSection(model: (), items: sectionItems)
                    return .fetchMemoSections([section])
                }
        case .refresh:
            return .just(.removeEmpty)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .activeDanjiIndex(index, danji, sections):
            state.activeDanji = danji
            state.activeIndex = index
            if index > 0 {
                state.isPreviousActive = true
            } else {
                state.isPreviousActive = false
            }
            if index < (state.danjiSections.first?.items.count ?? 0) - 1 {
                state.isNextActive = true
            } else {
                state.isNextActive = false
            }
            state.memoSections = sections
        case .fetchDanjiSections(let sections):
            state.danjiSections = sections
            let index = (sections.first?.items.count ?? 0) > 0 ? 0 : nil
            if let section = sections.first,
               let activeIndex = state.activeIndex ?? index {
                state.activeDanji = section.items[activeIndex].currentState
                state.activeIndex = activeIndex
            }
            if sections.first?.items.count ?? 0 > 1 {
                state.isNextActive = true
            }
        case let .insertDanjiSectionItem(indexPath, sectionItem):
            if let danji = state.danjiSections.first?.items.first,
               danji.currentState.color == .gray {
                state.danjiSections = [DanjiSection(model: (), items: [sectionItem])]
            } else {
                state.danjiSections.insert(sectionItem, at: indexPath)
            }
            if let section = state.danjiSections.first {
                if let activeIndex = state.activeIndex {
                    state.activeDanji = section.items[activeIndex].currentState
                } else if state.activeDanji == nil {
                    state.activeIndex = indexPath.item
                    state.activeDanji = sectionItem.currentState
                }
            }
        case let .insertMemoSectionItem(indexPath, sectionItem):
            if let memo = state.memoSections.first?.items.first,
               memo.currentState.memoe.mood == .nomal {
                state.memoSections = [MemoSection(model: (), items: [sectionItem])]
            } else {
                state.memoSections.insert(sectionItem, at: indexPath)
            }
        case let .updateDanjiSectionItem(indexPath, sectionItem):
            state.danjiSections[indexPath] = sectionItem
            if indexPath.item == state.activeIndex {
                state.activeDanji = sectionItem.currentState
            }
        case let .fetchMemoSections(sections):
            state.memoSections = sections
        default:
            break
        }
        
        return state
    }
    
    private func danjiIndexPath(forDanjiID danjiID: String, from state: State) -> IndexPath? {
        let section = 0
        let item = state.danjiSections[section].items.firstIndex { reactor in reactor.currentState.id == danjiID }
        if let item = item {
            return IndexPath(item: item, section: section)
        } else {
            return nil
        }
    }
    
    private func memoIndexPath(forMemoID memoID: String, from state: State) -> IndexPath? {
        let section = 0
        let item = state.memoSections[section].items.firstIndex { reactor in reactor.currentState.memoe.id == memoID }
        if let item = item {
            return IndexPath(item: item, section: section)
        } else {
            return nil
        }
    }
    
    func reactorForMenu() -> MenuViewReactor {
        var danjis: [Danji] = []
        if let danjiReactors = currentState.danjiSections.first?.items {
            danjis = danjiReactors.map { $0.currentState }.filter { $0.color != .gray }
        }
        return MenuViewReactor(provider: provider, danjis: danjis, activeDanji: currentState.activeDanji)
    }
    
    func reactorForMemoView(_ reactor: MemoCollectionCellReactor) -> MemoViewReactor {
        return MemoViewReactor(memo: reactor.currentState.memoe)
    }
    
    func reactorForMemoListView() -> MemoListViewReactor {
        var memos: [Memo] = []
        if let memoReactors = currentState.memoSections.first?.items {
            memos = memoReactors.map { $0.initialState.memoe }
        }
        return MemoListViewReactor(memos: memos)
    }
}
