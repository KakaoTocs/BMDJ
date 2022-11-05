//
//  LoginService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/06/19.
//

import Foundation

import FirebaseAuth
import UIKit

final class LoginService {
    private weak var viewController: UIViewController?
    private let services: [ServiceKind: LoginServiceProtocol]
    
    enum ServiceKind {
        case apple
        case google
    }
    
    init(services: [ServiceKind: LoginServiceProtocol]) {
        self.services = services
    }
    
    func set(parent viewController: UIViewController) {
        for service in services.values {
            service.set(parent: viewController)
        }
    }
    
    func login(service kind: ServiceKind) -> String? {
        if let service = services[kind],
            let (token, credential) = service.login() {
            if loginFirebase(authCredential: credential) {
                return token
            }
        }
        return nil
    }
    
    private func loginFirebase(authCredential: AuthCredential) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var authResult = false
        
        Auth.auth().signIn(with: authCredential) { result, error in
            if error == nil {
                authResult = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return authResult
    }
}
