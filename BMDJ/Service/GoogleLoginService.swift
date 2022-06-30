//
//  GoogleLoginService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/25.
//

import UIKit

import RxSwift
import GoogleSignIn
import FirebaseAuth

final class GoogleLoginService: LoginServiceProtocol {
    
    private let clientID = "997325203999-gdsfqdq974gtfn8ip7hkpvp3pkdv9qku.apps.googleusercontent.com"
    weak var viewController: UIViewController?
    private let disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func login() -> (String, AuthCredential)? {
        if let authentication = googleLogin(),
           let idToken = authentication.idToken,
           let token = requestToken(idToken: idToken),
           let authentication = getAuthCredential(idToken: idToken, accessToken: authentication.accessToken) {
            return (token, authentication)
        }
        return nil
    }
    
    private func getAuthCredential(idToken: String, accessToken: String) -> AuthCredential? {
        return GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
    
    private func requestToken(idToken: String) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var resultToken: String?
        
        AuthClient.shared.google(token: idToken)
            .subscribe(onNext: { token in
                resultToken = token
                semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        
        semaphore.wait()
        return resultToken
    }
    
    private func googleLogin() -> GIDAuthentication? {
        let semaphore = DispatchSemaphore(value: 0)
        let signInConfig = GIDConfiguration(clientID: clientID)
        var authentication: GIDAuthentication?
        
        if let viewController = viewController {
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController) { user, error in
                guard error == nil else { return }
                authentication = user?.authentication
                semaphore.signal()
            }
        } else  {
            return nil
        }
        semaphore.wait()
        return authentication
    }
}
