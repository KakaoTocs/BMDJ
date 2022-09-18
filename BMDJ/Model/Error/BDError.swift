//
//  BDError.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/03.
//

import Foundation

enum BDError: Error {
    case networkState
    case result
    case scheme
    case request
    case response
    case server
    case etc
}

extension BDError {
    var info: BDErrorProtocol {
        switch self {
        case .networkState:
            return BDErrorNetworkStatus()
        case .result:
            return BDErrorResult()
        case .scheme:
            return BDErrorAPIScheme()
        case .request:
            return BDErrorAPIRequest()
        case .response:
            return BDErrorAPIResponse()
        case .server:
            return BDErrorServer()
        case .etc:
            return BDErrorETC()
        }
    }
}
