//
//  AppDelegate.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/17.
//

import UIKit

import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "634NV3MK2C"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(UserDefaultService.shared.token)
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        
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
        #if DEBUG
        UserHabit.sessionStart("dev_4289ca4293b33fdaaa7ab19af85c28b29f732dca", withAutoTracking: true)
        #else
        UserHabit.sessionStart("4289ca4293b33fdaaa7ab19af85c28b29f732dca", withAutoTracking: true)
        #endif
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        if let fcmToken = fcmToken {
            let dataDict: [String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
}
