//
//  MemoDeleteJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

struct MemoDeleteJob: Job {
    let target: JobTarget = .memo
    let event: JobEvent = .delete
    
    let id: String
}
