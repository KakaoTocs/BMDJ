//
//  DanjiSyncer.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

final class DanjiSyncer {
    // MARK: - Property
    private let dataSyncEnvironment: DataSyncEnvironment
    
    // MARK: - Initializer
    init(dataSyncEnvironment: DataSyncEnvironment) {
        self.dataSyncEnvironment = dataSyncEnvironment
    }
    
    // MARK: - Interface
    func check(local localDanjis: [Danji], remote remoteDanjis: [Danji]) -> [BDJob] {
        let lastSyncDate = dataSyncEnvironment.lastSyncDate
        var jobs: [BDJob] = []
        
        remoteDanjis.forEach { remoteDanji in
            if let index = localDanjis.firstIndex(of: remoteDanji) {
                let localDanji = localDanjis[index]
                if localDanji.updateDate < remoteDanji.updateDate {
                    /// Local Danji 업데이트
                    let job: BDJob = .init(target: .danji(remoteDanji), event: .update, location: .local)
                    jobs.append(job)
                } else {
                    /// Remote Danji 업데이트
                    let job: BDJob = .init(target: .danji(localDanji), event: .update, location: .local)
                    jobs.append(job)
                }
            } else {
                let lastSyncDate = dataSyncEnvironment.lastSyncDate
                
                if remoteDanji.updateDate > lastSyncDate {
                    /// Local Danji 추가
                    let job: BDJob = .init(target: .danji(remoteDanji), event: .add, location: .local)
                    jobs.append(job)
                } else {
                    /// Remote Danji 삭제
                    let job: BDJob = .init(target: .danji(remoteDanji), event: .delete, location: .remote)
                    jobs.append(job)
                }
            }
            
            let restLocalDanjis = localDanjis.filter { !remoteDanjis.contains($0) }
            restLocalDanjis.forEach { localDanji in
                if localDanji.updateDate > lastSyncDate {
                    /// Remote Danji 추가
                    let job: BDJob = .init(target: .danji(localDanji), event: .add, location: .remote)
                    jobs.append(job)
                } else {
                    /// Local Danji 삭제
                    let job: BDJob = .init(target: .danji(localDanji), event: .delete, location: .local)
                    jobs.append(job)
                }
            }
        }
    }
}

/// Remote: a, b, c
/// Local: A, B, C
///
/// R, L
/// a, A
/// a, B
/// a, C
/// b, A
/// b, B
/// b, C
/// c, A
/// c, B
/// c, C
///
/// // 없는거 삭제
/// // 있는거 삭제
///
/// // createdDate: 생성 날짜 - 클라는 클라에 생성된, 서버는 서버에서 받아온
/// // updateDate: 수정된 날짜 - 클라는 클라 수정시 업데이트, 서버는 서버에서 받아온
/// // isUploaded or isOnlyLocal: 원격에만 존재시: isUploaded = nil, 서버에서 받을시: isUploaded = createdDate
///
/// // Local Date <- Action time              Onew Oold Xnew Xold
/// // Remote Memo Date <- Last updated time  Xold Xnew Onew Oold
///
