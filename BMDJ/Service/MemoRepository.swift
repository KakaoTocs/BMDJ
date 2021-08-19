//
//  MemoRepository.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/06.
//

import Foundation

import RxSwift
import RxRelay
import RxOptional

enum MemoEvent {
    case add(Memo)
    case create(Memo)
    case update(Memo)
    case move(String, Int)
    case refresh
}

final class MemoRepository: BaseService {
    
    // MARK: - Private Property
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    let event = PublishSubject<MemoEvent>()
    
    // MARK: - Init
    func fetchMemo() -> Observable<[Memo]> {
        let memos = provider.memoDataBaseService.all()
        return .just(memos)
    }
    
    func saveMemos(_ memos: [Memo]) -> Observable<Void> {
        provider.memoDataBaseService.write(memos: memos)
        return .just(())
    }
    
    func addMemo(memoCreate: MemoCreate) -> Observable<Memo> {
        return MemoClient.shared.add(memoCreate: memoCreate)
            .flatMap { memo in
                self.fetchMemo()
                .flatMap { [weak self] memos -> Observable<Memo> in
                    guard let `self` = self else { return .just(memo) }
                    return self.saveMemos([memo] + memos)
                        .map { memo }
                }
                .do(onNext: { memo in
                    self.event.onNext(.create(memo))
                })
            }
    }
}
