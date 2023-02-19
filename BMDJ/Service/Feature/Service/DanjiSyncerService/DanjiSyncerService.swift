//
//  DanjiSyncerService.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

final class DanjiSyncerService {
    // MARK: - Private Property
    private let danjiSyncer: DanjiSyncer
    private let memoSyncer: MemoSyncer
    
    // MARK: - Initializer
    init(danjiSycner: DanjiSyncer, memoSyncer: MemoSyncer) {
        self.danjiSyncer = danjiSycner
        self.memoSyncer = memoSyncer
    }
    
    // MARK: - Interface
    func check(local localDanjis: [Danji], remote remoteDanjis: [Danji]) -> [BDJob] {
        var jobs: [BDJob] = []
        jobs = danjiSyncer.check(local: localDanjis, remote: remoteDanjis)
        
        localDanjis.forEach { localDanji in
            if let remoteIndex = remoteDanjis.firstIndex(of: localDanji) {
                let memoJobs = memoSyncer.check(local: localDanji.memos, remote: remoteDanjis[remoteIndex].memos)
                jobs.append(contentsOf: memoJobs)
            }
        }
        return jobs
    }
}
