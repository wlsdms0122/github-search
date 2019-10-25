//
//  UserTableViewCellReactor.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import ReactorKit
import RxDataSources

class UserTableViewCellReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        /// 아바타 이미지 URL
        var avatarUrl: String
        
        /// 사용자 ID
        var userId: String
        
        /// 사용자 Public repository 갯수
        var publicRepositoryCount: Int
    }
    
    // MARK: - properties
    var initialState: State
    
    // MARK: - constructor
    init?(user: User) {
        guard let avatarUrl = user.avatarUrl,
            let id = user.id,
            let publicRepositoryCount = user.publicRepositoryCount else { return nil }
        
        initialState = State(avatarUrl: avatarUrl,
                             userId: id,
                             publicRepositoryCount: publicRepositoryCount)
    }
}
