//
//  LocalEnvironment.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

import Foundation

final class LocalEnvironment {
    private(set) var danjis: [Danji] = []
    var danjisID: [String] {
        danjis.map { $0.id }
    }
    private(set) var memos: [Memo] = []
    var memosID: [String] {
        memos.map { $0.id }
    }
    
    var jobs: [Job] = []
    
    func configuration(danjis: [Danji], memos: [Memo]) {
        self.danjis = danjis
        self.memos = memos
    }
    
    func compareDanji(_ remoteDanjis: [Danji]) -> (Bool, [Danji]) {
        var danjiJob: [Job] = []
        
//        let (deleteDanjis, deletedRemoteDanjis) = checkDanjiDelete(remoteDanjis)
//        if let deleteDanjis = deleteDanjis {
//            let deleteJob = deleteDanjis.map { DanjiDeleteJob(id: $0.id) as Job }
//            danjiJob.append(contentsOf: deleteJob)
//        }
        
        if danjis.isEmpty {
            let result = Repository.shared.danjiOverWrite(danjis: remoteDanjis)
            return (result, remoteDanjis)
        }
        checkDanjiPull(remoteDanjis)
        // (job, 변경 사항 적용된 remote)
        let (addDanjis, addedRemoteDanjis) = checkDanjiAdd(remoteDanjis)
        if let addDanjis = addDanjis {
            let addJob = addDanjis.map { DanjiAddJob(danji: $0) as Job }
            danjiJob.append(contentsOf: addJob)
        }
        
        let (sortIDs, sortedRemoteDanjis) = checkDanjiSort(addedRemoteDanjis)
        if let sortIDs = sortIDs {
            let sortJob = DanjiSortJob(ids: sortIDs) as Job
            danjiJob.append(sortJob)
        }
        
        let (moodDanjis, moodedRemoteDanjis) = checkDanjiMood(sortedRemoteDanjis)
        if let moodDanjis = moodDanjis {
            let moodJob = moodDanjis.map { DanjiUpdateJob(id: $0.id, mood: $0.mood) as Job }
            danjiJob.append(contentsOf: moodJob)
        }
        jobs.append(contentsOf: danjiJob)
        let result = danjisID == moodedRemoteDanjis.map { $0.id }
        
        return (result, moodedRemoteDanjis)
    }
    
//    private func checkDanjiDelete(_ remoteDanjis: [Danji]) -> ([Danji]?, [Danji]) {
//        var deleteIDs: [String] = []
//        let backupRemoteDanjis = remoteDanjis
//        var remoteDanjis = remoteDanjis
//        let remoteIDs = remoteDanjis.map { $0.id }
//
//        for remoteID in remoteIDs {
//            if !danjisID.contains(remoteID),
//               let remoteIndex = remoteDanjis.firstIndex(where: { $0.id == remoteID }) {
//                deleteIDs.append(remoteID)
//                remoteDanjis.remove(at: remoteIndex)
//            }
//        }
//
//        if deleteIDs.isEmpty {
//            return (nil, remoteDanjis)
//        } else {
//            let deleteDanjis = deleteIDs.map { id in
//                return backupRemoteDanjis.filter { $0.id == id }.first!
//            }
//            return (deleteDanjis, remoteDanjis)
//        }
//    }
    
    private func checkDanjiPull(_ remoteDanjis: [Danji]) {
        for danji in remoteDanjis {
            if !danjisID.contains(danji.id) {
                danjis.append(danji)
            }
        }
    }
    
    private func checkDanjiAdd(_ remoteDanjis: [Danji]) -> ([Danji]?, [Danji]) {
        var newIDs: [String] = []
        var remoteDanjis = remoteDanjis
        let remoteIDs = remoteDanjis.map { $0.id }
        
        for (index, localID) in danjisID.enumerated() {
            if !remoteIDs.contains(localID) {
                newIDs.append(localID)
                remoteDanjis.append(danjis[index])
            }
        }
        
        if newIDs.isEmpty {
            return (nil, remoteDanjis)
        } else {
            let addDanjis = newIDs.map { id in
                return danjis.first { $0.id == id }!
            }
            return (addDanjis, remoteDanjis)
        }
        
    }
    
    private func checkDanjiSort(_ remoteDanjis: [Danji]) -> ([String]?, [Danji]) {
        let remoteIDs = remoteDanjis.map { $0.id }
        
        if danjisID == remoteIDs {
            return (nil, remoteDanjis)
        } else {
            let sortedRemoteDanjis = danjisID.map { id in
                remoteDanjis.first { $0.id == id }!
            }
            return (danjisID, sortedRemoteDanjis)
        }
    }
    
    private func checkDanjiMood(_ remoteDanjis: [Danji]) -> ([Danji]?, [Danji]) {
        var moodDanjis: [Danji] = []
        var remoteDanjis = remoteDanjis
        let remoteIDs = remoteDanjis.map { $0.id }
        
        if danjisID != remoteIDs {
            return (nil, remoteDanjis)
        } else {
            for (index, remoteDanji) in remoteDanjis.enumerated() {
                let danji = danjis[index]
                if danji.updateDate > remoteDanji.updateDate,
                   danji.mood != remoteDanji.mood {
                    moodDanjis.append(danji)
                    remoteDanjis[index].mood = danji.mood
                }
            }
        }
        
        if moodDanjis.isEmpty {
            return (nil, remoteDanjis)
        } else {
            return (moodDanjis, remoteDanjis)
        }
    }
    
    func compareMemo(_ remoteMemos: [Memo]) -> (Bool, [Memo]) {
        var memoJob: [Job] = []
        
        if memos.isEmpty {
            let result = Repository.shared.memoOverWrite(memos: remoteMemos)
            return (result, remoteMemos)
        }
        checkMemoPull(remoteMemos)
        
        let (deleteMemos, deletedRemoteMemos) = checkMemoDelete(remoteMemos)
        if let deleteMemos = deleteMemos {
            let deleteJob = deleteMemos.map { MemoDeleteJob(id: $0.id) as Job }
            memoJob.append(contentsOf: deleteJob)
        }
        
        let (addMemos, addedRemoteMemos) = checkMemoAdd(deletedRemoteMemos)
        if let addMemos = addMemos {
            let addJob = addMemos.map { MemoAddJob(id: $0.id, danjiID: $0.danjiID, mood: $0.mood, text: $0.text, imageData: $0.imageData) as Job }
            memoJob.append(contentsOf: addJob)
        }
        
        let (textMemos, textedRemoteMemos) = checkMemoText(addedRemoteMemos)
        if let textMemos = textMemos {
            let textJob = textMemos.map { MemoUpdateJob(id: $0.id, text: $0.text) }
            memoJob.append(contentsOf: textJob)
        }
        
        jobs.append(contentsOf: memoJob)
        let result = memosID == textedRemoteMemos.map { $0.id }
        
        return (result, textedRemoteMemos)
    }
    
    private func checkMemoPull(_ remoteMemos: [Memo]) {
        for remoteMemo in remoteMemos {
            if !memosID.contains(remoteMemo.id) {
                memos.append(remoteMemo)
            }
        }
    }
    
    private func checkMemoDelete(_ remoteMemos: [Memo]) -> ([Memo]?, [Memo]) {
        var deleteIDs: [String] = []
        let backupRemoteMemos = remoteMemos
        var remoteMemos = remoteMemos
        let remoteIDs = remoteMemos.map { $0.id }
        
        for remoteID in remoteIDs {
            if !memosID.contains(remoteID),
               let remoteIndex = remoteMemos.firstIndex(where: { $0.id == remoteID }) {
                deleteIDs.append(remoteID)
                remoteMemos.remove(at: remoteIndex)
            }
        }
        
        if deleteIDs.isEmpty {
            return (nil, remoteMemos)
        } else {
            let deleteMemos = deleteIDs.map { id in
                return backupRemoteMemos.filter { $0.id == id }.first!
            }
            return (deleteMemos, remoteMemos)
        }
    }
    
    private func checkMemoAdd(_ remoteMemos: [Memo]) -> ([Memo]?, [Memo]) {
        var newIDs: [String] = []
        var remoteMemos = remoteMemos
        let remoteIDs = remoteMemos.map { $0.id }
        
        for (index, localID) in memosID.enumerated() {
            if !remoteIDs.contains(localID) {
                newIDs.append(localID)
                remoteMemos.append(memos[index])
            }
        }
        
        if newIDs.isEmpty {
            return (nil, remoteMemos)
        } else {
            let addMemos = newIDs.map { id in
                return memos.first { $0.id == id }!
            }
            return (addMemos, remoteMemos)
        }
    }
    
    private func checkMemoText(_ remoteMemos: [Memo]) -> ([Memo]?, [Memo]) {
        var textMemos: [Memo] = []
        var remoteMemos = remoteMemos
        let remoteIDs = remoteMemos.map { $0.id }
        
        if memosID != remoteIDs {
            return (nil, remoteMemos)
        } else {
            for (index, remoteMemo) in remoteMemos.enumerated() {
                let memo = memos[index]
                if memo.text != remoteMemo.text {
                    textMemos.append(memo)
                    remoteMemos[index].text = memo.text
                }
            }
        }
        
        if textMemos.isEmpty {
            return (nil, remoteMemos)
        } else {
            return (textMemos, remoteMemos)
        }
    }
    
}
