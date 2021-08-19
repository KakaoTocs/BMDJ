//
//  Memo.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

struct Memo: Codable, Equatable {
    let id: String
    let danjiID: String
    let mood: Danji.Mood
    let imageURLString: String?
    let text: String
    let createDate: Int
    
    var imageURL: URL? {
        return URL(string: imageURLString ?? "")
    }
    var dateString: String {
        let date = createDate.unixTimestampToDate
        let dateString = DateUtility.shared.formatter.string(from: date)
        return dateString
    }
    
    enum CodingKeys: String, CodingKey {
        case id, mood, text, createDate
        case imageURLString = "image"
        case danjiID = "danjiId"
    }
    
    static func empty(danjiID: String) -> Memo {
        return .init(id: UUID().uuidString, danjiID: danjiID, mood: .nomal, imageURLString: "https://firebasestorage.googleapis.com/v0/b/bmdj-1627404676793.appspot.com/o/Mock%2FEmptyImage.png?alt=media&token=5265397c-d9e6-4d54-929f-321e0c5e9c92", text: "올려주신 메모가 없습니다.\n메모를 작성해 보세요 :)", createDate: Int(Date().timeIntervalSince1970 * 1000))
    }
    
    static let empty: Memo = .init(id: "", danjiID: "", mood: .happy, imageURLString: "https://marginfan.com/files/attach/images/147/092/008/0a5591cdbc33a988805dede6cc63c934.png", text: "기영이 매매법.!\n간다 간다 간다 ~ 간다!\n뽀로로 뽀로 뽀로롱!\n아기상어 뚜 뚜루룻\n기영아 밥먹어야지\n아이리스1, 아이리스2\n오나의 귀신님 어비스 힘쎈여자 도봉순 어느날 우리집 현관에 멸망..어쩌고..\n공항가는 길\n오마이 비너스 주군의 태양\n비밀의 숲 낭만닥터 김사부 식샤를 합시다 블랙독\n뷰티인사이드\n채수빈\n표예진서현진\n이나영 유인영 신세경\n박보영 한지민 이청아 정소민\n박신혜 한효주 유인나 원진아 김태리\n소지섭 김래원 조정석 서인국 양세종 조승우", createDate: Int(Date().timeIntervalSince1970))
}

extension Memo {
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
