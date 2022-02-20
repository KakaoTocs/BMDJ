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
    var isShowGuide: Bool = false {
        didSet {
            if isShowGuide {
                setGuideHistory()
            }
        }
    }
    
    private init() {
        self.layoutScale = UIScreen.main.bounds.width / 375
        self.isLoggedIn = UserDefaultService.shared.readToken() != nil
        self.isShowGuide = fetchGuideHistory()
    }
    
    private func fetchGuideHistory() -> Bool {
        return UserDefaults.standard.bool(forKey: "AppService.GuideHistory")
    }
    
    private func setGuideHistory() {
        UserDefaults.standard.set(true, forKey: "AppService.GuideHistory")
    }
}
