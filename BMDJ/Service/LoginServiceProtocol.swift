//
//  LoginServiceProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/25.
//

import Foundation

import FirebaseAuth
import UIKit

protocol LoginServiceProtocol {
    func login() -> (String, AuthCredential)?
    func set(parent viewController: UIViewController)
}
