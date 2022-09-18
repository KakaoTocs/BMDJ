//
//  BDResponse.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/03.
//

import Foundation

struct BDResponse<T: Codable> {
    let data: T?
    let error: BDError?
}
