//
//  ServiceProvider.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

protocol ServiceProviderProtocol: class {
    var networkService: NetworkServiceProtocol { get }
}

class ServiceProvider: ServiceProviderProtocol {
    lazy var networkService: NetworkServiceProtocol = NetworkService(provider: self)
}
