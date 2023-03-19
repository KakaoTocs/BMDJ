//
//  MemoSyncer.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

final class MemoSyncer {
    // MARK: = Property
    private let dataSyncEnvironment: DataSyncEnvironment
    
    // MARK: - Initializer
    init(dataSyncEnvironment: DataSyncEnvironment) {
        self.dataSyncEnvironment = dataSyncEnvironment
    }
    
    // MARK: - Interface
    func check(local localMemos: [Memo], remote remoteMemos: [Memo]) -> [BDJob] {
        let lastSyncDate = dataSyncEnvironment.lastSyncDate
        var jobs: [BDJob] = []
        
        remoteMemos.forEach { remoteMemo in
            if let index = localMemos.firstIndex(of: remoteMemo) {
                let localMemo = localMemos[index]
                if localMemo.updateDate < remoteMemo.updateDate {
                    /// Local memo 업데이트
                    let job: BDJob = .init(target: .memo(remoteMemo), event: .update, location: .local)
                    jobs.append(job)
                } else {
                    /// Remote Memo 업데이트
                    let job: BDJob = .init(target: .memo(localMemo), event: .update, location: .remote)
                    jobs.append(job)
                }
            } else {
                let lastSyncDate = dataSyncEnvironment.lastSyncDate
                
                if remoteMemo.updateDate > lastSyncDate {
                    /// Local Memo 추가
                    let job: BDJob = .init(target: .memo(remoteMemo), event: .add, location: .local)
                    jobs.append(job)
                } else {
                    /// Remote Memo 삭제
                    let job: BDJob = .init(target: .memo(remoteMemo), event: .delete, location: .remote)
                    jobs.append(job)
                }
            }
        }
        
        let restLocalMemos = localMemos.filter { !remoteMemos.contains($0) }
        restLocalMemos.forEach { localMemo in
            if localMemo.updateDate > lastSyncDate {
                /// Remote Memo 추가
                let job: BDJob = .init(target: .memo(localMemo), event: .add, location: .remote)
                jobs.append(job)
            } else {
                /// Local Memo 삭제
                let job: BDJob = .init(target: .memo(localMemo), event: .delete, location: .local)
                jobs.append(job)
            }
        }
    }
}