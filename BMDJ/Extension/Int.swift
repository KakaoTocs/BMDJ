//
//  Int.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/15.
//

import Foundation

extension Int {
    
    var unixTimestampToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
}
