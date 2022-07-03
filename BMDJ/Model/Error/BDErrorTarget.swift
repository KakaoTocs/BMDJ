//
//  BDErrorTarget.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/03.
//

enum BDErrorTarget: String, Codable {
    case app = "APP"
    case server = "SERVER"
    case all = "APP & SERVER"
}

extension BDErrorTarget {
    var emoji: String {
        switch self {
        case .app:
            return "📱"
        case .server:
            return "🛰"
        case .all:
            return "👨‍👩‍👧‍👦"
        }
    }
}
