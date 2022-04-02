//
//  Danji.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

struct Danji: Codable {
    enum Mood: String, Codable {
        case happy = "HAPPY"
        case sad = "SAD"
        case nomal = "NOMAL"
        case empty = "EMPTY"
        
        var descriptin: String {
            switch self {
            case .happy:
                return "맑음"
            case .sad:
                return "슬픔"
            case .nomal:
                return "보통"
            case .empty:
                return "없음"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .happy:
                return .happy48
            case .sad:
                return .sad48
            case .nomal:
                return .normal48
            case .empty:
                return .normal48
            }
        }
        
        var gradient: [UIColor] {
            switch self {
            case .happy:
                return [.background3Gradarion1, .background3Gradarion2]
            case .sad:
                return [.background4Gradarion1, .background4Gradarion2]
            case .nomal:
                return [.white, .white]
            case .empty:
                return [.init(hex: 0xFFFBEF), .init(hex: 0xE1E5FF)]
            }
        }
    }
    
    enum Color: String, Codable {
        case red = "RED"
        case yellow = "YELLOW"
        case green = "GREEN"
        case blue = "BLUE"
        case purple = "PURPLE"
        case gray = "GRAY"
        
        var color: UIColor {
            switch self {
            case .red:
                return .sub1
            case .yellow:
                return .sub2
            case .green:
                return .sub3
            case .blue:
                return .sub4
            case .purple:
                return .primary
            case .gray:
                return .gray
            }
        }
        
        var image: UIImage? {
            switch self {
            case .red:
                return .potLRedWhole
            case .yellow:
                return .potLYellowWhole
            case .green:
                return .potLGreenWhole
            case .blue:
                return .potLBlueWhole
            case .purple:
                return .potLPurpleWhole
            case .gray:
                return .potGrayWhole
            }
        }
        
        var thumbImage: UIImage? {
            switch self {
            case .red:
                return .potRed
            case .yellow:
                return .potYellow
            case .green:
                return .potGreen
            case .blue:
                return .potBlue
            case .purple:
                return .potPurple
            case .gray:
                return nil
            }
        }
    }
    
    var id: String
    let userID: String
    let color: Color
    let name: String
    var stock: StockInfo
    let volume: String
    var mood: Mood
    let createDate: Int
    let endDate: Int
    var updateDate: Int
    let dDay: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, color, name, dDay, stock, volume, mood, createDate, endDate, updateDate
    }
}

extension Danji {
    static var empty: Danji {
        return .init(id: "empty", userID: "", color: .gray, name: "장독대 애칭 지어주러 가기!", stock: .init(id: "000000", name: "000000"), volume: "보유 수량이 보여집니다.", mood: .happy, createDate: .init(), endDate: .init(), updateDate: .init(), dDay: 1)
    }
    
    var dDayString: String {
        get {
            let timeInterval = endDate - Int(Date().timeIntervalSince1970 * 1000)
            let dDayResult = Int(timeInterval / 1000 / 86400)
            if dDayResult > 0 {
                return "D-\(dDayResult)"
            } else if dDayResult == 0 {
                return "D-Day"
            } else {
                return "Expire"
            }
        }
    }
    
    var isHappy: Bool {
        return mood == .happy
    }
    
    var danjiImage: UIImage? {
        return UIImage(named: "potPurple")
    }
    
    var landImage: UIImage? {
        if isHappy {
            return UIImage(named: "happySoil")
        } else {
            return UIImage(named: "sadSoil")
        }
    }
}

extension Danji: Identifiable {
}

