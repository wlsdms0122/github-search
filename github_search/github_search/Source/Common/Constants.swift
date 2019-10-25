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
    
    enum Font {
        static let light: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .light)
        static let regular: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let bold: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        static let extraBold: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
    }
    
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
        
        static let gray: UIColor = {
            if #available(iOS 11.0, *) {
                return UIColor(named: "gray")!
            } else {
                return UIColor(hex: "#666666")
            }
        }()
    }
}
