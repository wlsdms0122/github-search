//
//  Constants.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    // base screen display weight
    static let weight: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIScreen.main.bounds.width / 375.0
            
        default:
            return 1
        }
    }()
    
    enum Color {
        static let clear: UIColor = .clear
        
        static let white: UIColor = {
            if #available(iOS 11.0, *) {
                return UIColor(named: "white")!
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }()
        
        static let black: UIColor = {
            if #available(iOS 11.0, *) {
                return UIColor(named: "black")!
            } else {
                return UIColor(hex: "#000000")
            }
        }()
    }
}
