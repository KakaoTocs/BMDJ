//
//  AppDelegate.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/17.
//

import UIKit

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(UserDefaultService.shared.token)
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let serviceProvider = ServiceProvider()
        let reactor = HomeViewReactor(provider: serviceProvider)
        let homeVC = HomeViewController(reactor: reactor)
        let naviVC = UINavigationController(rootViewController: homeVC)
        naviVC.isNavigationBarHidden = true
        
        let loginVC = LoginViewController()
        loginVC.reactor = .init()
        if AppService.shared.isLoggedIn {
            window?.rootViewController = naviVC
        } else {
            window?.rootViewController = loginVC
        }
        
        return true
    }
}

