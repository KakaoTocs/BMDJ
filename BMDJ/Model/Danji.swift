//
//  Danji.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

import RealmSwift

struct Danji: Codable {
    enum Mood: String, Codable {
        case happy = "HAPPY"
        case sad = "SAD"
        case nomal = "NOMAL"
        
        var descriptin: String {
            switch self {
            case .happy:
                return "맑음"
            case .sad:
                return "슬픔"
            case .nomal:
                return "보통"
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
    
    let id: String
    let userID: String
    let color: Color
    let name: String
    let stock: Stock
    let volume: String
    var mood: Mood
    let createDate: Date
    let endDate: Date
    let dDayTimeStamp: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case dDayTimeStamp = "dDay"
        case id, color, name, stock, volume, mood, createDate, endDate
    }
}

extension Danji {
    static var empty: Danji {
        let time = Date().addingTimeInterval(86399).timeIntervalSince1970
        return .init(id: "empty", userID: "", color: .gray, name: "장독대 애칭 지어주러 가기!", stock: .empty, volume: "보유 수량이 보여집니다.", mood: .happy, createDate: .init(), endDate: .init(), dDayTimeStamp: Int(time))
    }
    
    var dDayString: String {
        get {
            let timeInterval = dDayTimeStamp - Int(Date().timeIntervalSince1970)
            let dDayResult = Int(timeInterval / 86400)
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

