//
//  LoginServiceProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/25.
//

import Foundation

import FirebaseAuth

protocol LoginServiceProtocol {
    func login() -> (String, AuthCredential)?
}
