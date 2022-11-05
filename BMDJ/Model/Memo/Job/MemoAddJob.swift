//
//  MemoAddJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//
import Foundation

struct MemoAddJob: Job {
    let target: JobTarget = .memo
    let event: JobEvent = .add
    
    let id: String
    let danjiID: String
    let mood: DanjiLite.Mood
    let text: String
    let imageData: Data?
}

extension MemoAddJob {
    var memoCreate: MemoCreate {
        if let data = imageData {
            return .init(mood: mood, text: text, danjiId: danjiID, image: .init(data: data))
        } else {
            return .init(mood: mood, text: text, danjiId: danjiID, image: nil)
        }
    }
}
