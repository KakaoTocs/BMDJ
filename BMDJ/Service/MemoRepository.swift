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
    case delete(Memo)
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
    
    func updateMemo(_ memo: Memo) -> Observable<Memo> {
        return MemoClient.shared.update(id: memo.id, text: memo.text)
            .flatMap { _ in
                return self.fetchMemo()
                    .flatMap { [weak self] memos -> Observable<Memo> in
                        guard let `self` = self else { return .just(memo) }
                        var newMemos = memos
                        if let index = memos.firstIndex(of: memo) {
                            newMemos[index] = memo
                        }
                        return self.saveMemos(newMemos)
                            .map { _ in memo }
                            .do(onNext: { _ in
                                self.event.onNext(.update(memo))
                            })
                    }
            }
    }
    
    func deleteMemo(_ memo: Memo) -> Observable<Bool> {
        return MemoClient.shared.delete(id: memo.id)
            .flatMap { _ in
                self.fetchMemo()
                    .flatMap { [weak self] memos -> Observable<Bool> in
                        guard let `self` = self else { return .just(false) }
                        var newMemos = memos
                        if let index = memos.firstIndex(of: memo) {
                            newMemos.remove(at: index)
                        }
                        return self.saveMemos(newMemos)
                            .map { _ in true }
                            .do(onNext: { _ in
                                self.event.onNext(.delete(memo))
                            })
                    }
            }
    }
}
