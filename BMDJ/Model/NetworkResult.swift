//
//  NetworkResult.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/28.
//

import Foundation

struct NetworkResult<T: Codable>: Codable {
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
