//
//  MemoUpdateJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

struct MemoUpdateJob: Job {
    let target: JobTarget = .memo
    let event: JobEvent = .update
    
    let id: String
    let text: String
}
