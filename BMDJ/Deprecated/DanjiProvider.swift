//
//  DanjiProvider.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/20.
//

import Foundation

import RxSwift
import RxRelay

final class DanjiProvider {
    
    private typealias DanjiRecord = (danji: Danji, count: Int, updatedAt: Date)
    
    // MARK: - Private Property
    private let queue = DispatchQueue(label: "DanjiProvider", qos: .utility)
    private let danjiRelay = BehaviorRelay<[String: DanjiRecord]>(value: [:])
    private let danjiObservable: Observable<[String: DanjiRecord]>
    let observable: Observable<[Danji]>
    
    // MARK: - Init
    init() {
        danjiObservable = danjiRelay
            .asObservable()
            .subscribe(on: SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: UUID().uuidString))
        
        observable = danjiObservable
            .map { $0.map { $0.value.danji } }
    }
    
    func add(_ danji: Danji) {
        queue.sync {
            var danjiRecords = self.danjiRelay.value
            if let record = danjiRecords[danji.id] {
                danjiRecords[danji.id] = DanjiRecord(danji: danji, count: record.count + 1, updatedAt: Date())
            } else {
                danjiRecords[danji.id] = DanjiRecord(danji: danji, count: 1, updatedAt: Date())
            }
            self.danjiRelay.accept(danjiRecords)
        }
    }
    
    func update(_ danji: Danji) {
        queue.sync {
            var danjiRecords = self.danjiRelay.value
            if let record = danjiRecords[danji.id] {
                danjiRecords[danji.id] = DanjiRecord(danji: danji, count: record.count + 1, updatedAt: Date())
            }
            self.danjiRelay.accept(danjiRecords)
        }
    }
    
    func retain(id: String) {
        queue.sync {
            var danjiRecords = self.danjiRelay.value
            if var record = danjiRecords[id] {
                record.count += 1
                danjiRecords[id] = record
                self.danjiRelay.accept(danjiRecords)
            }
        }
    }
    
    func release(id: String) {
        queue.sync {
            var danjiRecords = self.danjiRelay.value
            if var record = danjiRecords[id] {
                record.count -= 1
                if record.count < 1 {
                    danjiRecords.removeValue(forKey: id)
                    danjiRelay.accept(danjiRecords)
                }
            }
        }
    }
    
    func danji(_ danji: Danji) -> Observable<Danji> {
        return danjiObservable
            .map { $0[danji.id] }
            .map { $0!.danji }
            .share(replay: 1, scope: .whileConnected)
    }
}
