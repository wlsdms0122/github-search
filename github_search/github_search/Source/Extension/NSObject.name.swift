//
//  NSObject.name.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation

extension NSObject {
    static var name: String {
        return String(describing: self)
    }
}
