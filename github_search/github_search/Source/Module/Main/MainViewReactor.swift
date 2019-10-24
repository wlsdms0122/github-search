//
//  MainViewReactor.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import ReactorKit

class MainViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: - properties
    var initialState: State
    private let networkService: NetworkServiceProtocol
    
    // MARK: - constructor
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        initialState = State()
    }
}
