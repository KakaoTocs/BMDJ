//
//  UserDefaultService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/16.
//

import Foundation

final class UserDefaultService {
    
    static let shared = UserDefaultService()
    
    private(set) var token: String?
    
    private init() {
        self.token = readToken()
    }
    
    func removeToken() {
        self.token = nil
        UserDefaults.standard.removeObject(forKey: "DANJI_TOKEN")
    }
    
    func write(_ token: String) {
        self.token = token
        UserDefaults.standard.setValue(token, forKey: "DANJI_TOKEN")
    }
    
    func readToken() -> String? {
        return UserDefaults.standard.string(forKey: "DANJI_TOKEN")
    }
}
