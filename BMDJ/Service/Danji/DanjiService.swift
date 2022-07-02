//
//  DanjiService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/02.
//

import Foundation

final class DanjiService {
    
    private let danjiClient: DanjiClient
    
    init(danjiClient: DanjiClient) {
        self.danjiClient = danjiClient
    }
    
    func getDanjis() -> [DanjiLite] {
        danjiClient.lowLevelAll() ?? []
    }
    
    private func getMemos(danjiID: String) -> [Memo] {
        return []
    }
}
