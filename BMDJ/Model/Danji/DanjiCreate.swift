//
//  DanjiCreate.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/13.
//

import Foundation

struct DanjiCreate: Codable {
    var color: Danji.Color = .purple
    var name: String = ""
    var stockName: String = ""
    var volume: String = ""
    var mood: Danji.Mood = .happy
    var endDate: Int = Int(Date().timeIntervalSince1970 * 1000)
    var dDay: Int = 0
}

extension DanjiCreate {
    var danji: Danji {
        return .init(id: "Danji-\(UUID().uuidString)", userID: "User", color: color, name: name, stock: .init(id: "Stock-\(UUID().uuidString)", name: stockName), volume: volume, mood: mood, createDate: Int(Date().timeIntervalSince1970 * 1000), endDate: endDate, updateDate: Int(Date().timeIntervalSince1970 * 1000), dDay: dDay)
    }
}
