//
//  JobService.swift
//  BMDJ
//
//  Created by κΉμ§μ° on 2022/03/06.
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
    private let provider = ServiceProvider.shared
    
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
        print("π JobService μ΄κΈ°ν μλ£")
    }
    
    deinit {
        print("π JobService μ’λ£ μ μ₯")
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
        print("π’ Job μ€ν μμ")
        if crashCount == 0,
           !isNeedCheck {
            print("π’ μ΄λ²€νΈ μμ")
        } else if isRunning {
           print("π’ μ΄λ―Έ μ€νμ€...")
        } else if !isConnected {
            print("π’ μΈν°λ· μ°κ²° X...")
        } else {
            isRunning = true
            print("π’ Job μλ² μμ²­")
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
                            print("π° Request: \(job.description)")
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
            print("π’ Job μ€ν μ’λ£")
        }
    }
    
    private func getMemoAll(danjis: [Danji]) -> [Memo]? {
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
