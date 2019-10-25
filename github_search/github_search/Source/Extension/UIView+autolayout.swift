//
//  UIView+autolayout.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addAutolayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
    
    func addAutolayoutSubviews(_ subviews: [UIView]) {
        subviews.forEach(addAutolayoutSubview)
    }
}
