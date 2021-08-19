//
//  BMDJTypography.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/17.
//

import UIKit

enum BMDJTypography {
    
    enum AppleSDGothicNeo: String {
        case regular = "AppleSDGothicNeo-Regular"
        case medium = "AppleSDGothicNeo-Medium"
        case semiBold = "AppleSDGothicNeo-SemiBold"
        case bold = "AppleSDGothicNeo-Bold"
    }
    struct BMDJFont {
        let font: AppleSDGothicNeo
        let size: CGFloat
        
        var uiFont: UIFont {
            return UIFont(name: font.rawValue, size: size)!
        }
    }
    
    struct Regular {
        static let h1 = BMDJFont(font: .regular, size: 50 * AppService.shared.layoutScale)
        static let h2 = BMDJFont(font: .regular, size: 24 * AppService.shared.layoutScale)
        
        static let body1 = BMDJFont(font: .regular, size: 20 * AppService.shared.layoutScale)
        static let body2 = BMDJFont(font: .regular, size: 16 * AppService.shared.layoutScale)
        static let body3 = BMDJFont(font: .regular, size: 14 * AppService.shared.layoutScale)
        
        static let caption = BMDJFont(font: .regular, size: 12 * AppService.shared.layoutScale)
    }
    
    struct Medium {
        static let body2 = BMDJFont(font: .medium, size: 19 * AppService.shared.layoutScale)
        
        static let caption = BMDJFont(font: .medium, size: 12 * AppService.shared.layoutScale)
    }
    
    struct SemiBold {
        static let h2 = BMDJFont(font: .semiBold, size: 24 * AppService.shared.layoutScale)
        
        static let h3 = BMDJFont(font: .semiBold, size: 16 * AppService.shared.layoutScale)
        
        static let body2 = BMDJFont(font: .semiBold, size: 16 * AppService.shared.layoutScale)
    }
    
    struct Bold {
        static let h1 = BMDJFont(font: .bold, size: 50 * AppService.shared.layoutScale)
        static let h2 = BMDJFont(font: .bold, size: 24 * AppService.shared.layoutScale)
        
        static let body1 = BMDJFont(font: .bold, size: 20 * AppService.shared.layoutScale)
        static let body2 = BMDJFont(font: .bold, size: 16 * AppService.shared.layoutScale)
        static let bold16 = BMDJFont(font: .bold, size: 16 * AppService.shared.layoutScale)
    }
}

extension UIFont {
    // MARK: - Regualr
    class var regularH1: UIFont {
        return BMDJTypography.Regular.h1.uiFont
    }
    class var regularH2: UIFont {
        return BMDJTypography.Regular.h2.uiFont
    }
    
    class var regularBody1: UIFont {
        return BMDJTypography.Regular.body1.uiFont
    }
    class var regularBody2: UIFont {
        return BMDJTypography.Regular.body2.uiFont
    }
    class var regularBody3: UIFont {
        return BMDJTypography.Regular.body3.uiFont
    }
    
    class var regularCaption: UIFont {
        return BMDJTypography.Regular.caption.uiFont
    }
    
    // MARK: - Medium
    class var mediumCaption: UIFont {
        return BMDJTypography.Medium.caption.uiFont
    }
    
    class var mediumBody2: UIFont {
        return BMDJTypography.Medium.body2.uiFont
    }
    
    // MARK: - SemiBold
    class var semiBoldBody2: UIFont {
        return BMDJTypography.SemiBold.body2.uiFont
    }
    
    class var semiBoldH2: UIFont {
        return BMDJTypography.SemiBold.h2.uiFont
    }
    
    class var semiBoldH3: UIFont {
        return BMDJTypography.SemiBold.h3.uiFont
    }
    
    // MARK: - Bold
    class var BoldBody1: UIFont {
        return BMDJTypography.Bold.body1.uiFont
    }
    
    class var BoldH2: UIFont {
        return BMDJTypography.Bold.h2.uiFont
    }
    
    class var BoldH1: UIFont {
        return BMDJTypography.Bold.h1.uiFont
    }
    
    class var BoldBody2: UIFont {
        return BMDJTypography.Bold.body2.uiFont
    }
    class var Bold16: UIFont {
        return BMDJTypography.Bold.bold16.uiFont
    }
}
