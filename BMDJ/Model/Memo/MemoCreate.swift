//
//  MemoCreate.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/06.
//

import UIKit

struct MemoCreate: Codable {
    let uuid = UUID().uuidString
    var mood: Danji.Mood = .happy
    var text: String = ""
    var danjiId: String = ""
    var image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case mood, text, danjiId, image
    }
    
    init(mood: Danji.Mood, text: String, danjiId: String, image: UIImage?) {
        self.mood = mood
        self.text = text
        self.danjiId = danjiId
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mood = try values.decode(Danji.Mood.self, forKey: .mood)
        text = try values.decode(String.self, forKey: .text)
        danjiId = try values.decode(String.self, forKey: .danjiId)
        image = try UIImage(data: values.decode(Data.self, forKey: .image))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mood, forKey: .mood)
        try container.encode(text, forKey: .text)
        try container.encode(danjiId, forKey: .danjiId)
        if let data = image?.pngData() {
            try container.encode(data, forKey: .image)
        }
    }
}
