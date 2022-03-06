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
    var endDate: Int = Int(Date().timeIntervalSince1970)
    var dDay: Int = Int(Date().addingTimeInterval(86400 * 30).timeIntervalSince1970)
}
