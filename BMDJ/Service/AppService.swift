//
//  AppService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/27.
//

import UIKit

final class AppService {
    
    static let shared = AppService()
    
    let layoutScale: CGFloat
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        let versionAndBuild: String = "v \(version)"
        return versionAndBuild
    }
    var isLoggedIn: Bool
    
    private init() {
        self.layoutScale = UIScreen.main.bounds.width / 375
        self.isLoggedIn = UserDefaultService.shared.readToken() != nil
        
        print(isLoggedIn)
        
    }
}
