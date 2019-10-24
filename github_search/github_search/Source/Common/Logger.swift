//
//  Logger.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation

class Logger {
    static func verbose(_ message: Any = "", tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let className = (file as NSString).lastPathComponent.components(separatedBy: ".").first!
        let tag = tag.isEmpty ? tag : "[\(tag)] "
        print(" VERBOSE 💛 \(className).\(function):\(line) \(tag)\(message)")
        #endif
    }
    
    static func debug(_ message: Any = "", tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let className = (file as NSString).lastPathComponent.components(separatedBy: ".").first!
        let tag = tag.isEmpty ? tag : "[\(tag)] "
        print(" DEBUG 💚 \(className).\(function):\(line) \(tag)\(message)")
        #endif
    }
    
    static func info(_ message: Any = "", tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let className = (file as NSString).lastPathComponent.components(separatedBy: ".").first!
        let tag = tag.isEmpty ? tag : "[\(tag)] "
        print(" INFO 💙 \(className).\(function):\(line) \(tag)\(message)")
        #endif
    }
    
    static func warning(_ message: Any = "", tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let className = (file as NSString).lastPathComponent.components(separatedBy: ".").first!
        let tag = tag.isEmpty ? tag : "[\(tag)] "
        print(" WARNING 🧡 \(className).\(function):\(line) \(tag)\(message)")
        #endif
    }
    
    static func error(_ message: Any = "", tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let className = (file as NSString).lastPathComponent.components(separatedBy: ".").first!
        print(" ERROR ❤️ \(className).\(function):\(line) \(tag)\(message)")
        #endif
    }
}
