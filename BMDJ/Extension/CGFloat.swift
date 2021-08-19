//
//  CGFloat.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/27.
//

import UIKit

extension CGFloat {
    static func scale(_ value: CGFloat) -> CGFloat {
        value * AppService.shared.layoutScale
    }
    
    init(layoutValue: CGFloat) {
        self = layoutValue * AppService.shared.layoutScale
    }
}
