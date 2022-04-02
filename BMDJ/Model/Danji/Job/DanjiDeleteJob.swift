//
//  DanjiDeleteJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

struct DanjiDeleteJob: Job {
    let target: JobTarget = .danji
    let event: JobEvent = .delete
    
    let id: String
}
