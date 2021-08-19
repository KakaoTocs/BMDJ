//
//  UIColor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/17.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let r = min(max(CGFloat(red) / 255.0, 0), 1)
        let g = min(max(CGFloat(green) / 255.0, 0), 1)
        let b = min(max(CGFloat(blue) / 255.0, 0), 1)
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
}
