//
//  Stock.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/22.
//

import Foundation

enum Index: String, Codable {
    case kospi = "KOSPI"
    case kosdaq = "KOSDAQ"
}

struct Stock: Codable {
    
    let name: String
    let code: String
    let index: Index
    
    static let empty: Stock = .init(name: "주식명이 보여집니다.", code: "000000", index: .kospi)
    
    init(name: String, code: String, index: Index) {
        self.name = name
        self.code = code
        self.index = index
    }
    
    init?(name: String?, code: String?, market: String?) {
        if let name = name,
           let code = code,
           let market = market,
           let index = Index(rawValue: market) {
            self.name = name
            self.code = code
            self.index = index
        } else {
            return nil
        }
    }
}

extension Stock: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.index == rhs.index && lhs.code == rhs.code
    }
}
