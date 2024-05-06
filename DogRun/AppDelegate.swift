//
//  AppDelegate.swift
//  DogRun
//
//  Created by 이재희 on 4/18/24.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import iamport_ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        
        let modifier = AnyModifier { request in
            var req = request
            req.addValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HeaderLiteral.sesacKey.rawValue)
            req.addValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HeaderLiteral.authorization.rawValue)
            return req
        }
        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // 결제
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Iamport.shared.receivedURL(url)
        return true
    }


}

