//
//  AppCoordinator.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit

/// Route from app initialze
class AppCoordinator {
    // MARK: - route enumeration
    enum Route {
        case main
    }

    // MARK: - properties
    let window: UIWindow
    let provider: ServiceProviderProtocol
    
    // MARK: - constructor
    init(provider: ServiceProviderProtocol, window: UIWindow) {
        self.provider = provider
        self.window = window
    }
    
    func present(for route: Route) {
        let viewController = get(for: route)
        
        switch route {
        case .main:
            // Present intro view
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
    func get(for route: Route) -> UIViewController {
        switch route {
        case .main:
            let reactor = MainViewReactor(networkService: provider.networkService)
            let viewController = MainViewController()
            
            // DI
            viewController.reactor = reactor
            
            let rootViewController: RootViewController = RootViewController(rootViewController: viewController)
            return rootViewController
        }
    }
}
