//
//  BMDJColor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/17.
//

import UIKit

enum BMDJColor: Int {
    case primary = 0x5021B5
    
    case secondary1 = 0xFF5D5D
    case secondary2 = 0x0C82E6
    
    case sub1 = 0xE55656
    case sub2 = 0xF7BA31
    case sub3 = 0x19C27B
    case sub4 = 0x4D60DF
    
    case font1 = 0x1E1E1E
    case font2 = 0x777777
    case font3 = 0x6E6E6E
    case font4 = 0xA0A0A0
    case font5 = 0xdddddd
    
    case background1 = 0xFFFFFF
    case background2 = 0xF5F5F5
    case background3Gradarion1 = 0xFDDC84
    case background3Gradarion2 = 0xFD8968
    case background4Gradarion1 = 0x242424
    case background4Gradarion2 = 0x080820
    
    case memo1Gradient1 = 0x75C1FF
    case memo1Gradient2 = 0xD9E2FF
    case memo2Gradient1 = 0xFFA3B5
    case memo2Gradient2 = 0xFFE4D9
    
    case line = 0xF0F0F0
    case border = 0x979797
    
    case naver = 0x20C028
    case kakao = 0xFFE059
    case google = 0xFFFFFE
    case apple = 0x0D1E27
    
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue)
    }
}

extension UIColor {
    class var primary: UIColor {
        return BMDJColor.primary.uiColor
    }
    
    class var secondary1: UIColor {
        return BMDJColor.secondary1.uiColor
    }
    class var secondary2: UIColor {
        return BMDJColor.secondary2.uiColor
    }
    
    class var sub1: UIColor {
        return BMDJColor.sub1.uiColor
    }
    class var sub2: UIColor {
        return BMDJColor.sub2.uiColor
    }
    class var sub3: UIColor {
        return BMDJColor.sub3.uiColor
    }
    class var sub4: UIColor {
        return BMDJColor.sub4.uiColor
    }
    
    class var font1: UIColor {
        return BMDJColor.font1.uiColor
    }
    class var font2: UIColor {
        return BMDJColor.font2.uiColor
    }
    class var font3: UIColor {
        return BMDJColor.font3.uiColor
    }
    class var font4: UIColor {
        return BMDJColor.font4.uiColor
    }
    class var font5: UIColor {
        return BMDJColor.font5.uiColor
    }
    
    class var background1: UIColor {
        return BMDJColor.background1.uiColor
    }
    class var background2: UIColor {
        return BMDJColor.background2.uiColor
    }
    class var background3Gradarion1: UIColor {
        return BMDJColor.background3Gradarion1.uiColor
    }
    class var background3Gradarion2: UIColor {
        return BMDJColor.background3Gradarion2.uiColor
    }
    class var background4Gradarion1: UIColor {
        return BMDJColor.background4Gradarion1.uiColor
    }
    class var background4Gradarion2: UIColor {
        return BMDJColor.background4Gradarion2.uiColor
    }
    
    class var memo1Gradient1: UIColor {
        return BMDJColor.memo1Gradient1.uiColor.withAlphaComponent(0.3)
    }
    class var memo1Gradient2: UIColor {
        return BMDJColor.memo1Gradient2.uiColor.withAlphaComponent(0.3)
    }
    class var memo2Gradient1: UIColor {
        return BMDJColor.memo2Gradient1.uiColor.withAlphaComponent(0.3)
    }
    class var memo2Gradient2: UIColor {
        return BMDJColor.memo2Gradient2.uiColor.withAlphaComponent(0.3)
    }
    
    class var line: UIColor {
        return BMDJColor.line.uiColor
    }
    class var border: UIColor {
        return BMDJColor.border.uiColor
    }
    
    class var naver: UIColor {
        return BMDJColor.naver.uiColor
    }
    class var kakao: UIColor {
        return BMDJColor.kakao.uiColor
    }
    class var google: UIColor {
        return BMDJColor.google.uiColor
    }
    class var apple: UIColor {
        return BMDJColor.apple.uiColor
    }
}
