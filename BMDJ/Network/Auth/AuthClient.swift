//
//  AuthClient.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/30.
//

import Foundation

import RxSwift
import Alamofire
import RxAlamofire

final class AuthClient {
    
    static let shared = AuthClient()
    
    private let decoder = JSONDecoder()
    let disposeBag = DisposeBag()
    
    private init() {}
    
    func google(token: String) -> Observable<String> {
        return RxAlamofire.request(AuthRouter.google(idToken: token))
            .data()
            .decode(type: TokenResponse.self, decoder: decoder)
            .map { $0.idToken }
    }
    
    func apple(userID: String) -> Observable<String> {
        return RxAlamofire.request(AuthRouter.apple(userID: userID))
            .data()
            .decode(type: TokenResponse.self, decoder: decoder)
            .map { $0.idToken }
    }
    
    func withdrawal(token: String) -> Observable<Bool> {
        return RxAlamofire.request(AuthRouter.withdrawal(token: token))
            .data()
            .map { _ in true }
    }
}

struct TokenResponse: Codable {
    let idToken: String
    
    enum CodingKeys: String, CodingKey {
        case idToken = "access_token"
    }
}
