//
//  BDJob.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

struct BDJob {
    var target: BDJobTarget
    var event: BDJobEvent
    var location: BDJobLocation
}

extension BDJob {
    var description: String {
        return "\(target.description) - \(event.rawValue)"
    }
}
