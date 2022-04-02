//
//  DanjiUpdateJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

struct DanjiUpdateJob: Job {
    let target: JobTarget = .danji
    let event: JobEvent = .update
    
    let id: String
    let mood: Danji.Mood
}
