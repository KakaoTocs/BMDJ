//
//  Job.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/06.
//

protocol Job {
    var target: JobTarget { get }
    var event: JobEvent { get }
}

extension Job {
    var description: String {
        return "\(target) - \(event)"
    }
}
