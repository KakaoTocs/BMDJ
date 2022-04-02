//
//  Memo.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

struct Memo: Codable, Equatable {
    var id: String
    var danjiID: String
    let mood: Danji.Mood
    var imageURLString: String?
    var imageBase64: String?
    var text: String
    let createDate: Int
    var updateDate: Int
    
    var imageURL: URL? {
        return URL(string: imageURLString ?? "")
    }
    var dateString: String {
        let date = createDate.unixTimestampToDate
        let dateString = DateUtility.shared.formatter.string(from: date)
        return dateString
    }
    
    enum CodingKeys: String, CodingKey {
        case id, mood, text, createDate, updateDate, imageBase64
        case imageURLString = "image"
        case danjiID = "danjiId"
    }
    
    public static func ==(lhs: Memo, rhs: Memo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func empty(danjiID: String) -> Memo {
        return .init(id: UUID().uuidString, danjiID: danjiID, mood: .nomal, imageURLString: "https://firebasestorage.googleapis.com/v0/b/bmdj-1627404676793.appspot.com/o/Mock%2FEmptyImage.png?alt=media&token=5265397c-d9e6-4d54-929f-321e0c5e9c92", text: "올려주신 메모가 없습니다.\n메모를 작성해 보세요 :)", createDate: Int(Date().timeIntervalSince1970 * 1000), updateDate: Int(Date().timeIntervalSince1970 * 1000))
    }
}

extension Memo {
    var imageData: Data? {
        if let imageBase64 = imageBase64 {
            return Data(base64Encoded: imageBase64, options: .init(rawValue: 0))
        }
        return nil
    }
    
    var moodGradient: [CGColor] {
        if mood == .sad {
            return [UIColor.memo1Gradient1, UIColor.memo1Gradient2].map { $0.cgColor }
        } else if mood == .happy {
            return [UIColor.memo2Gradient1, UIColor.memo2Gradient2].map { $0.cgColor }
        } else {
            return [UIColor.white, UIColor.white].map { $0.cgColor }
        }
    }
}
