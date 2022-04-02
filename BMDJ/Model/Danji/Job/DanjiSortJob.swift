//
//  DanjiSortJob.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

struct DanjiSortJob: Job {
    let target: JobTarget = .danji
    let event: JobEvent = .sort
    
    let ids: [String]
}
