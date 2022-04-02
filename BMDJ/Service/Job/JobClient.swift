//
//  JobClient.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/09.
//

import Foundation
import RxSwift

final class JobClient {
    
    private let danjiClient = DanjiClient.shared
    private let memoClient = MemoClient.shared
    private let disposeBag = DisposeBag()
    
    static let shared = JobClient()
    
    private init() {
    }
    
    func request(_ job: Job) -> Bool? {
        switch job.target {
        case .danji:
            return requestDanjiJob(job)
        case .memo:
            return requestMemoJob(job)
        }
    }
    
    private func requestDanjiJob(_ job: Job) -> Bool? {
        let semaphore = DispatchSemaphore.init(value: 0)
        var result: Bool?
        
        switch job.event {
        case .delete:
            result = nil
            semaphore.signal()
        case .add:
            if let danjiAddJob = job as? DanjiAddJob {
                danjiClient.plant(danji: danjiAddJob.danjiCreate)
                    .bind { danji in
                        result = Repository.shared.danjiUpdate(id: danjiAddJob.id, newID: danji.id, stock: danji.stock)
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        case .sort:
            if let danjiSortJob = job as? DanjiSortJob {
                danjiClient.sort(ids: danjiSortJob.ids)
                    .bind { _ in
                        result = true
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        case .update:
            if let danjiUpdateJob = job as? DanjiUpdateJob {
                danjiClient.mood(id: danjiUpdateJob.id, mood: danjiUpdateJob.mood)
                    .bind { _ in
                        result = true
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        }
        semaphore.wait()
        print("📡 \(job.description) -> result: \(result)")
        return result
    }
    
    private func requestMemoJob(_ job: Job) -> Bool? {
        let semaphore = DispatchSemaphore.init(value: 0)
        var result: Bool?
        
        switch job.event {
        case .delete:
            if let memoDeleteJob = job as? MemoDeleteJob {
                memoClient.delete(id: memoDeleteJob.id)
                    .bind { _ in
                        result = true
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        case .add:
            if let memoAddJob = job as? MemoAddJob {
                dump(memoAddJob.memoCreate)
                memoClient.add(memoCreate: memoAddJob.memoCreate)
                    .bind { memo in
                        result = Repository.shared.memoUpdate(id: memoAddJob.id, newID: memo.id, imageURLString: memo.imageURLString)
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        case .update:
            if let memoUpdateJob = job as? MemoUpdateJob {
                memoClient.update(id: memoUpdateJob.id, text: memoUpdateJob.text)
                    .bind { _ in
                        result = true
                        semaphore.signal()
                    }
                    .disposed(by: disposeBag)
            }
        default:
            result = nil
            semaphore.signal()
        }
        
        semaphore.wait()
        print("📡 \(job.description) -> result: \(result)")
        return result
    }
}
