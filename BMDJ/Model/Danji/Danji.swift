//
//  Danji.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/02.
//

import Foundation

struct Danji: Codable {
    let id: String
    let color: DanjiLite.Color
    let name: String
    let stock: StockInfo
    let volume: String
    var mood: DanjiLite.Mood
    let dDay: Int
    let endDate: Int
    let memos: [Memo]
    
    init(danjiLite: DanjiLite, memos: [Memo]) {
        self.id = danjiLite.id
        self.color = danjiLite.color
        self.name = danjiLite.name
        self.stock = danjiLite.stock
        self.volume = danjiLite.volume
        self.mood = danjiLite.mood
        self.dDay = danjiLite.dDay
        self.endDate = danjiLite.endDate
        self.memos = memos
    }
}

extension Danji {
    var dDayString: String {
        get {
            let timeInterval = endDate - Int(Date().timeIntervalSince1970 * 1000)
            let dDayResult = Int(timeInterval / 1000 / 86400)
            if dDayResult > 0 {
                return "D-\(dDayResult)"
            } else if dDayResult == 0 {
                return "D-Day"
            } else {
                return "Expire"
            }
        }
    }
    
    var isHappy: Bool {
        return mood == .happy
    }
}
