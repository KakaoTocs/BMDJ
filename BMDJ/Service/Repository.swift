//
//  Repository.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/09.
//

import Foundation

import RxSwift

final class Repository {
    
    static let shared: Repository = .init()
    
    private(set) var danjis: [Danji] = []
    private(set) var memos: [Memo] = []
    
    private let databaseService = DatabaseService.shared
    private let jobService = JobService.shared
    
    let danjiEvent = PublishSubject<DanjiEvent>()
    let memoEvent = PublishSubject<MemoEvent>()
    
    private init() {
        self.danjis = danjiFetch()
        self.memos = memoFetch()
    }
    
    func danjiFetch() -> [Danji] {
        return databaseService.danjis
    }
    
    private func danjiSave(_ danjis: [Danji]) -> Bool {
        let result = databaseService.danjiWrite(danjis: danjis)
        if result {
            self.danjis = danjiFetch()
        }
        return result
    }
    
    func danjiOverWrite(danjis: [Danji]) -> Bool {
        let result = danjiSave(danjis)
        if result {
            jobService.isNeedCheck = true
            danjiEvent.onNext(.refresh)
        }
        return result
    }
    
    func danjiAdd(danjiCreate: DanjiCreate) -> Bool {
        var danjis = danjis
        danjis.insert(danjiCreate.danji, at: 0)
        let result = danjiSave(danjis)
        if result {
            jobService.isNeedCheck = true
            danjiEvent.onNext(.refresh)
        }
        return result
    }
    
    func danjiUpdate(id: String, newID: String, stock: StockInfo) -> Bool {
        var danjis = danjis
        if let index = danjis.firstIndex(where: { $0.id == id }) {
            danjis[index].id = newID
            danjis[index].stock = stock
            let result = danjiSave(danjis)
            let memoResult = memoUpdateDanjiID(id: id, newID: newID)
            if result, memoResult {
                jobService.isNeedCheck = true
                danjiEvent.onNext(.update(id, danjis[index]))
            }
            return result && memoResult
        }
        return false
    }
    
    func danjiUpdate(id: String, mood: Danji.Mood) -> Bool {
        var danjis = danjis
        if let index = danjis.firstIndex(where: { $0.id == id }) {
            danjis[index].mood = mood
            danjis[index].updateDate = Int(Date().timeIntervalSince1970 * 1000)
            let result = danjiSave(danjis)
            if result {
                jobService.isNeedCheck = true
                danjiEvent.onNext(.refresh)
            }
            return result
        }
        return false
    }
    
    func danjiMove(index: Int, to destinationIndex: Int) -> Bool {
        var danjis = danjis
        var danji = danjis.remove(at: index)
        danji.updateDate = Int(Date().timeIntervalSince1970 * 1000)
        danjis.insert(danji, at: destinationIndex)
        let result = danjiSave(danjis)
        if result {
            jobService.isNeedCheck = true
            danjiEvent.onNext(.move(danji.id, destinationIndex))
        }
        return result
    }
    
    func memoFetch() -> [Memo] {
        return databaseService.memos
    }
    
    func memoFetch(_ danjiID: String) -> [Memo] {
        let memos = databaseService.memos
        return memos.filter { $0.danjiID == danjiID }
    }
    
    private func memoSave(_ memos: [Memo]) -> Bool {
        let result = databaseService.memoWrite(memos: memos)
        if result {
            self.memos = memoFetch()
        }
        return result
    }
    
    func memoOverWrite(memos: [Memo]) -> Bool {
        let result = memoSave(memos)
        if result {
            jobService.isNeedCheck = true
            memoEvent.onNext(.refresh)
        }
        return result
    }
    
    func memoAdd(memoCreate: MemoCreate) -> Bool {
        var memos = memos
        memos.insert(memoCreate.memo, at: 0)
        let result = memoSave(memos)
        if result {
            jobService.isNeedCheck = true
            memoEvent.onNext(.add(memoCreate.memo))
        }
        return result
    }
    
    func memoUpdate(id: String, newID: String, imageURLString: String?) -> Bool {
        var memos = memos
        if let index = memos.firstIndex(where: { $0.id == id }) {
            memos[index].id = newID
            memos[index].imageURLString = imageURLString
            memos[index].imageBase64 = nil
            let result = memoSave(memos)
            if result {
                jobService.isNeedCheck = true
                memoEvent.onNext(.refresh)
            }
            return result
        }
        return false
    }
    
    func memoUpdateDanjiID(id: String, newID: String) -> Bool {
        var memos = memos
        let targetMemos = memos.filter { $0.danjiID == id }
        for memo in targetMemos {
            if let index = memos.firstIndex(where: { $0.danjiID ==  memo.danjiID }) {
                memos[index].danjiID = newID
            } else {
                return false
            }
        }
        let result = memoSave(memos)
        if result {
            jobService.isNeedCheck = true
            memoEvent.onNext(.refresh)
        }
        return result
    }
    
    func memoUpdate(id: String, text: String) -> Bool {
        var memos = memos
        if let index = memos.firstIndex(where: { $0.id == id }) {
            memos[index].text = text
            memos[index].updateDate = Int(Date().timeIntervalSince1970 * 1000)
            let result = memoSave(memos)
            if result {
                jobService.isNeedCheck = true
                memoEvent.onNext(.refresh)
            }
            return result
        }
        return false
    }
    
    func memoDelete(id: String) -> Bool {
        var memos = memos
        if let index = memos.firstIndex(where: { $0.id == id }) {
            let memo = memos.remove(at: index)
            let result = memoSave(memos)
            if result {
                jobService.isNeedCheck = true
                memoEvent.onNext(.delete(memo))
            }
            return result
        }
        return false
    }
}
