//
//  Date.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/02.
//

import Foundation

extension Date {
    var string: String {
        return DateUtility.shared.formatter.string(from: self)
    }
}
