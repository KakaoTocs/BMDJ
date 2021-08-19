//
//  DanjiRepository.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import Foundation

import RxSwift
import RxRelay
import RxOptional

enum DanjiEvent {
    case add(Danji)
    case create(Danji)
    case update(Danji)
    case move(String, Int)
    case refresh
}

final class DanjiRepository: BaseService {
    
    // MARK: - Private Property
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    let event = PublishSubject<DanjiEvent>()
    
    // MARK: - Init
    func fetchDanjis() -> Observable<[Danji]> {
        let danjis = provider.danjiDataBaseService.all()
        return .just(danjis)
    }
    
    func saveDanjis(_ danjis: [Danji]) -> Observable<Void> {
        provider.danjiDataBaseService.write(danjis: danjis)
        return .just(())
    }
    
    func addDanji(danjiCreate: DanjiCreate) -> Observable<Danji> {
        return DanjiClient.shared.plant(danji: danjiCreate)
            .flatMap { danji in
                self.fetchDanjis()
                .flatMap { [weak self] danjis -> Observable<Danji> in
                    guard let `self` = self else { return .empty() }
                    return self.saveDanjis([danji] + danjis).map { danji }
                }
                .do(onNext: { danji in
                    self.event.onNext(.create(danji))
                })
            }
    }
    
    func updateMood(id: String, mood: Danji.Mood) -> Observable<Danji> {
        return DanjiClient.shared.mood(id: id, mood: mood)
            .flatMap { _ in
                self.fetchDanjis()
                    .flatMap { currentDanjis -> Observable<Danji> in
                        var danjis = currentDanjis
                        if let index = danjis.firstIndex(where: { $0.id == id }) {
                            danjis[index].mood = mood
                            return self.saveDanjis(danjis)
                                .map { danjis[index] }
                        }
                        return .just(.empty)
                    }
                    .do(onNext: { danji in
                        self.event.onNext(.update(danji))
                    })
            }
    }
    
    func moveDanji(index: Int, to destinationIndex: Int) -> Observable<Danji> {
        fetchDanjis()
            .flatMap { currentDanjis -> Observable<Danji> in
                var danjis = currentDanjis
                let danji = danjis.remove(at: index)
                danjis.insert(danji, at: destinationIndex)
                let ids = danjis.map { $0.id }
                return DanjiClient.shared.sort(ids: ids)
                    .map { danjis -> Observable<Void> in
                        return self.saveDanjis(danjis)
                    }
                    .do(onNext: { _ in
                        self.event.onNext(.move(danji.id, destinationIndex))
                    })
                    .map { _ in danji }
            }
            .do(onNext: { danji in
                self.event.onNext(.move(danji.id, destinationIndex))
            })
    }
}
