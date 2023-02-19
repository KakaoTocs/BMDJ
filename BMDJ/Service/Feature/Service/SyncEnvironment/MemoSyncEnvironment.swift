//
//  MemoSyncEnvironment.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

import Foundation

final class MemoSyncEnvironment {
    // MARK: - Property
    private(set) var lastSyncDate: Int = 0
    private let userDefaultsKey: String = "MemoSyncEnvironment"

    // MARK: - Initializer
    init() {
        configure()
    }
    
    // MARK: - Private Method
    private func configure() {
        self.lastSyncDate = read()
    }
    
    private func write(date: Int) {
        UserDefaults.standard.setValue(date, forKey: userDefaultsKey)
    }
    
    private func read() -> Int {
        return UserDefaults.standard.integer(forKey: userDefaultsKey)
    }
}
