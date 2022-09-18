//
//  BDErrorProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/03.
//

protocol BDErrorProtocol {
    var code: Int { get }
    var description: String { get }
    var message: String { get }
    var type: BDErrorType { get }
    var target: BDErrorTarget { get }
}
