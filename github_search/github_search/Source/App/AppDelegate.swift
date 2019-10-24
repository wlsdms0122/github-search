//
//  AppDelegate.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Window 생성
        let window = UIWindow(frame: UIScreen.main.bounds)
        // Root view controller 및 Key window 지정
        window.rootViewController = MainViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}

