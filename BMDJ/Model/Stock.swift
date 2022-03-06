//
//  Stock.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/22.
//

import Foundation

struct Stock: Codable {
    let id: String
    let name: String
    
    static let empty: Stock = .init(id: "", name: "주식명이 보여집니다.")
}
