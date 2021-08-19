//
//  Date+Utility.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/02.
//

import Foundation

struct DateUtility {
    
    static let shared = DateUtility()
    
    let formatter: DateFormatter
    
    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
    }
}
