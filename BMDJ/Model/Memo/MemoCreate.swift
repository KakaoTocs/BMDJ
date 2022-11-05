//
//  MemoCreate.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/06.
//

import UIKit

struct MemoCreate: Codable {
    let uuid = UUID().uuidString
    var mood: DanjiLite.Mood = .happy
    var text: String = ""
    var danjiId: String = ""
    var image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case mood, text, danjiId, image
    }
    
    init(mood: DanjiLite.Mood, text: String, danjiId: String, image: UIImage?) {
        self.mood = mood
        self.text = text
        self.danjiId = danjiId
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mood = try values.decode(DanjiLite.Mood.self, forKey: .mood)
        text = try values.decode(String.self, forKey: .text)
        danjiId = try values.decode(String.self, forKey: .danjiId)
        image = try UIImage(data: values.decode(Data.self, forKey: .image))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mood, forKey: .mood)
        try container.encode(text, forKey: .text)
        try container.encode(danjiId, forKey: .danjiId)
        if let data = image?.jpegData(compressionQuality: 0.8) {
            try container.encode(data, forKey: .image)
        }
    }
}

extension MemoCreate {
    var memo: Memo {
        return .init(id: "User-\(UUID().uuidString)", danjiID: danjiId, mood: mood, imageURLString: nil, imageBase64: image?.jpegData(compressionQuality: 0.8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                      , text: text, createDate: Int(Date().timeIntervalSince1970 * 1000), updateDate: Int(Date().timeIntervalSince1970 * 1000))
    }
    
    var imageData: Data? {
        return image?.jpegData(compressionQuality: 0.8)
    }
}
