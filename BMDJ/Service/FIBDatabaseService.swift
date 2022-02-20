//
//  FIBDatabaseService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/01/21.
//

import FirebaseDatabase

final class FIBDatabaseService {
    
    private let reference: DatabaseReference
    private let queue = DispatchQueue(label: "FIBDatabaseService", qos: .utility)
    
    static let shared = FIBDatabaseService()
    
    private init() {
        reference = Database.database(url: "https://bmdj-1627404676793-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    func requestStock() -> [Stock]? {
        var result: [Stock]?
        let semaphore = DispatchSemaphore(value: 0)
        
        queue.async { [weak self] in
            guard let self = self else {
                semaphore.signal()
                return
            }
            self.reference.child("stocks").getData { error, snapshot in
                if let value = snapshot.value as? [Dictionary<String, String>] {
                    result = value.compactMap { .init(name: $0["name"], code: $0["code"], market: $0["market"]) }
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return result
    }
}
