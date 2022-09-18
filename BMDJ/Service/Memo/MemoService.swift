//
//  MemoService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/02.
//

import Foundation

final class MemoService {
    
    private let memoClient: MemoClient
    
    init(memoClient: MemoClient) {
        self.memoClient = memoClient
    }
    
    func getMemos(danjiLiteID: String) -> [Memo]? {
        let response = memoClient.allW(danjiID: danjiLiteID)
        if let memos = response.data {
            return memos
        } else {
            return nil
        }
        // skip, size
//        var resultMemos: [Memo] = []
//        var currentMemos: [Memo] = memoClient.lowLevelAll(danjiID: danjiLiteID) ?? []
//        resultMemos = currentMemos
//        while currentMemos.count == 5 {
//            currentMemos = memoClient.lowLevelAll(danjiID: danjiLiteID) ?? []
//            resultMemos.append(contentsOf: currentMemos)
//        }
//        return resultMemos
    }
    
    func add(memoCreate: MemoCreate) -> Bool {
        let response = memoClient.addW(memoCreate: memoCreate)
        if let _ = response.data {
            return true
        } else {
            return false
        }
    }
    
    func update(new memo: Memo) -> Bool {
        let response = memoClient.updateW(id: memo.id, text: memo.text)
        if let _ = response.data {
            return true
        } else {
            return false
        }
    }
    
    func delete(id: String) -> Bool {
        let response = memoClient.deleteW(id: id)
        if let resultID = response.data,
           id == resultID {
            return true
        } else {
            return false
        }
    }
}
