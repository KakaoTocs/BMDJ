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
    
    private let appDependency: AppDependency
    let gcmMessageIDKey = "634NV3MK2C"
    var window: UIWindow?
    
    private override init() {
        self.appDependency = .resolve()
        super.init()
    }
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("API token: \(UserDefaultService.shared.token ?? "nil")")
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let rootVC = RootViewController(reactor: appDependency.rootViewReactor)
        let naviVC = UINavigationController(rootViewController: rootVC)
        naviVC.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        
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
        print("Firebase registration token: \(fcmToken ?? "nil")")
        if let fcmToken = fcmToken {
            let dataDict: [String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
}

struct AppDependency {
    let rootViewReactor: RootViewReactor
    
    static func resolve() -> AppDependency {
        let repository: Repository = .shared
        let userDefaultService: UserDefaultService = .shared
        let appleLoginService: AppleLoginService = .init()
        let googleLoginService: GoogleLoginService = .init()
        let loginService: LoginService = .init(services: [.apple: appleLoginService, .google: googleLoginService])
        
        let danjiAddViewReactor: DanjiAddViewReactor = .init(dependency: .init(repository: repository), payload: .init())
        let danjiManageViewReactorFactory: DanjiSortViewReactor.Factory = .init(dependency: .init(repository: repository))
        let memoViewReactorFactory: MemoViewReactor.Factory = .init(dependency: .init())
        let memoAddViewViewReactorFactory: MemoAddViewReactor.Factory = .init(dependency: .init(repository: repository))
        let memoEditViewReactorFactory: MemoEditViewReactor.Factory = .init(dependency: .init(repository: repository))
        let settingViewReactor: SettingViewReactor = .init(dependency: .init(), payload: .init())
        
        let memoListViewReactorFactory: MemoListViewReactor.Factory = .init(dependency: .init(
            memoViewReactorFactory: memoViewReactorFactory,
            memoEditViewReactorFactory: memoEditViewReactorFactory,
            repository: repository)
        )
        let menuViewReactorFactory: MenuViewReactor.Factory = .init(dependency: .init(
            danjiAddViewReactor: danjiAddViewReactor,
            danjiManageViewReactorFactory: danjiManageViewReactorFactory,
            memoAddViewReactorFactory: memoAddViewViewReactorFactory,
            settingViewReactor: settingViewReactor,
            repository: repository)
        )
        
        let homeViewReactor: HomeViewReactor = .init(dependency: .init(
            menuViewReactorFactory: menuViewReactorFactory,
            memoViewReactorFactory: memoViewReactorFactory,
            memoListReatorFactory: memoListViewReactorFactory,
            memoAddReactorFactory: memoAddViewViewReactorFactory,
            repository: repository
        ), payload: .init())
        let loginViewReactor: LoginViewReactor = .init(dependency: .init(homeViewReactor: homeViewReactor, loginService: loginService), payload: .init())
        
        let rootViewReactor: RootViewReactor = .init(dependency: .init(homeViewReactor: homeViewReactor, loginViewReactor: loginViewReactor, userDefaultService: userDefaultService), payload: .init())
        
        return .init(rootViewReactor: rootViewReactor)
    }
}
