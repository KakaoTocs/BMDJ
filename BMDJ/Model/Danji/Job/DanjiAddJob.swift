//
//  DanjiAddJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

import Foundation

struct DanjiAddJob: Job {
    let target: JobTarget = .danji
    let event: JobEvent = .add
    
    let id: String
    let color: Danji.Color
    let name: String
    let stockName: String
    let volume: String
    let mood: Danji.Mood
    let endDate: Int
    let dDay: Int
    
    init(danji: Danji) {
        self.id = danji.id
        self.color = danji.color
        self.name = danji.name
        self.stockName = danji.stock.name
        self.volume = danji.volume
        self.mood = danji.mood
        self.endDate = danji.endDate
        self.dDay = danji.dDay
    }
}

extension DanjiAddJob {
    var danjiCreate: DanjiCreate {
        return .init(color: color, name: name, stockName: stockName, volume: volume, mood: mood, endDate: endDate, dDay: dDay)
    }
}
