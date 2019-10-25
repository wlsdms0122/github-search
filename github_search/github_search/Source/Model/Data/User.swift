//
//  User.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation

struct User: Codable {
    let avatarUrl: String?
    let id: String?
    let publicRepositoryCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case id = "login"
        case publicRepositoryCount = "public_repos"
    }
}
