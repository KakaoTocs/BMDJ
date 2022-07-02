//
//  JobService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

import Foundation

import RxSwift
import RxRelay

enum JobServiceEvent {
    case running
    case stop
}

final class JobService {
    
    static let shared = JobService()
    
    private let queue = DispatchQueue(label: "JobCenter", qos: .utility)
    
    private let jobClient = JobClient.shared
    private let danjiClient = DanjiClient.shared
    private let memoClient = MemoClient.shared
    private let localEnvironment = LocalEnvironment()
    
    private var executeTimer: Timer?
    private let disposeBag = DisposeBag()
    
    let event = PublishSubject<JobServiceEvent>()
    
    var isConnected: Bool = true
    var isRunning: Bool = false {
        didSet {
            if isRunning {
                event.onNext(.running)
            } else {
                event.onNext(.stop)
            }
        }
    }
    var isNeedCheck: Bool = false
    var crashCount = 0
    
    private init() {
        setup()
        print("🎞 JobService 초기화 완료")
    }
    
    deinit {
        print("🎞 JobService 종료 저장")
    }
    
    func setup() {
        executeTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            DispatchQueue.global().async { [weak self] in
                self?.excute()
            }
        }
        executeTimer?.fire()
    }
    
    private func excute() {
        print("🛢 Job 실행 시작")
        if crashCount == 0,
           !isNeedCheck {
            print("🛢 이벤트 없음")
        } else if isRunning {
           print("🛢 이미 실행중...")
        } else if !isConnected {
            print("🛢 인터넷 연결 X...")
        } else {
            isRunning = true
            print("🛢 Job 서버 요청")
            if let remoteDanjis = danjiClient.lowLevelAll(),
               let remoteMemos = getMemoAll(danjis: remoteDanjis) {
                localEnvironment.configuration(danjis: Repository.shared.danjis, memos: Repository.shared.memos)
                let (_, danjis) = localEnvironment.compareDanji(remoteDanjis)
                let (_, memos) = localEnvironment.compareMemo(remoteMemos)
                if !localEnvironment.jobs.isEmpty {
                    let danjiLocalResult = Repository.shared.danjiOverWrite(danjis: danjis)
                    let memoLocalResult = Repository.shared.memoOverWrite(memos: memos)
                    if danjiLocalResult,
                       memoLocalResult {
                        let jobs = localEnvironment.jobs
                        for job in jobs {
                            print("🛰 Request: \(job.description)")
                            let result = jobClient.request(job)
                            if let result = result,
                               !result {
                                isRunning = false
                                return
                            }
                            localEnvironment.jobs.remove(at: 0)
                            if job.target == .danji,
                               job.event == .add {
                                localEnvironment.jobs.removeAll()
                                isRunning = false
                                return
                            }
                        }
                    }
                }
                crashCount = 0
                isNeedCheck = false
            } else {
                crashCount += 1
            }
            isRunning = false
            print("🛢 Job 실행 종료")
        }
    }
    
    private func getMemoAll(danjis: [DanjiLite]) -> [Memo]? {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "LocalEnvironment", qos: .utility, attributes: .concurrent)
        let resultQueue = DispatchQueue(label: "ResultQueue")
        let semaphore = DispatchSemaphore(value: 0)
        var memosDictionary: [String: [Memo]] = [:] {
            didSet {
                print(memosDictionary)
            }
        }
        var isFail: Bool = false
        
        for danji in danjis {
            queue.async(group: group) { [weak self] in
                if let currentMemos = self?.memoClient.lowLevelAll(danjiID: danji.id) {
                    resultQueue.sync {
                        memosDictionary[danji.id] = currentMemos
                    }
                } else {
                    isFail = true
                }
            }
        }
        
        group.notify(queue: queue) {
            semaphore.signal()
        }
        semaphore.wait()
        if isFail {
            return nil
        }
        var result: [Memo] = []
        for danji in danjis {
            if let memos = memosDictionary[danji.id] {
                result += memos
            }
        }
        return result
    }
}
