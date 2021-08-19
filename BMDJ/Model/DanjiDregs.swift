//
//  DanjiDregs.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/14.
//

import Foundation

struct DanjiDregs: Codable {
    let danjiID: String
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case danjiID = "danjiId"
        case index
    }
}
