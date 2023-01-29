//
//  MemoFetcher.swift
//  BMDJ
//
//  Created by 김진우 on 2023/01/28.
//

final class MemoFetcher: MemoFetcherProtocol {
    func fetch(_ localMemos: [Memo], _ remoteMemos: [Memo]) -> [Memo] {
        if localMemos.isEmpty {
            return remoteMemos
        }
        
        return fetchList(localMemos, remoteMemos)
    }
    
    private func fetchList(_ localMemos: [Memo], _ remoteMemos: [Memo]) -> [Memo] {
        var resultMemos: [Memo] = localMemos
        
        for remoteIndex in 0...remoteMemos.count {
            for localIndex in 0...localMemos.count {
                if remoteMemos[remoteIndex].id == localMemos[localIndex].id {
                    let updatedMemo = fetchDetail(localMemos[localIndex], resultMemos[remoteIndex])
                    resultMemos[localIndex] = updatedMemo
                    break
                }
                if localIndex == localMemos.count {
                    resultMemos.append(remoteMemos[remoteIndex])
                }
            }
        }
        
        return resultMemos
    }
    
    private func fetchDetail(_ localMemo: Memo, _ remoteMemo: Memo) -> Memo {
        if localMemo.updateDate > remoteMemo.updateDate {
            return localMemo
        } else {
            return remoteMemo
        }
    }
}
