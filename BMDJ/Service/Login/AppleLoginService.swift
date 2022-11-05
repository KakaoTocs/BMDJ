//
//  AppleLoginService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/25.
//

import UIKit

import RxSwift
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices

final class AppleLoginService: NSObject, LoginServiceProtocol {
    
    let disposeBag = DisposeBag()
    
    private var appleLoginCompletion: ((String?) -> Void)?
    
    override init() {}
    
    func login() -> (String, AuthCredential)? {
        if let appleToken = appleLogin(),
           let token = requestToken(token: appleToken),
           let authentication = getAuthCredential(token: appleToken) {
            return (token, authentication)
        }
        return nil
    }
    
    func set(parent viewController: UIViewController) {
    }
    
    private func getAuthCredential(token: String) -> AuthCredential? {
        return OAuthProvider.credential(withProviderID: "apple.com", idToken: token, rawNonce: randomNonceString())
    }
    
    private func requestToken(token: String) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var resultToken: String?
        
        AuthClient.shared.apple(userID: token)
            .subscribe(onNext: { id in
                resultToken = id
                semaphore.signal()
            })
            .disposed(by: disposeBag)
        semaphore.wait()
        return resultToken
    }
    
    private func appleLogin() -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var resultToken: String?
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        appleLoginCompletion = { token in
            resultToken = token
            semaphore.signal()
        }
        semaphore.wait()
        return resultToken
    }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({$0.isKeyWindow}).first

        return keyWindow!
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let appleToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
            appleLoginCompletion?(appleToken)
        default:
            appleLoginCompletion?(nil)
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleLoginCompletion?(nil)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
}
