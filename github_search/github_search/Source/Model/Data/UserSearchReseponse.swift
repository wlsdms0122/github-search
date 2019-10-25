//
//  UserSearchReseponse.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation

struct UserSearchReseponse: Codable {
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}
