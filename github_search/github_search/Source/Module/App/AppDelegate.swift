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
    private let serviceProvider: ServiceProviderProtocol = ServiceProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Window 생성
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // App coordinator 생성 후 root view controller 전환
        let coordinator = AppCoordinator(provider: serviceProvider, window: window)
        coordinator.present(for: .main)
        return true
    }
}

