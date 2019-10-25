//
//  String+regex.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation

extension String {
    func substring(start: Character, last: Character) -> String? {
        guard let firstIndex = self.firstIndex(of: start), let lastIndex = self.lastIndex(of: last) else { return nil }
        return String(self[self.index(firstIndex, offsetBy: 1) ..< lastIndex])
    }
}
