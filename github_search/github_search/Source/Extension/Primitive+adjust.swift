//
//  Primitive+adjust.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit

extension Int {
    func adjust() -> CGFloat {
        return CGFloat(self) * Constants.weight
    }
}

extension Float {
    func adjust() -> CGFloat {
        return CGFloat(self) * Constants.weight
    }
}

extension Double {
    func adjust() -> CGFloat {
        return CGFloat(self) * Constants.weight
    }
}
