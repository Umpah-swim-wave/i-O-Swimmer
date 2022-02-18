//
//  Logger.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2022/02/18.
//

import Foundation

class Logger {
    static func debugDescription<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        if let obj = object {
            print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
        } else {
            print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
        }
        #endif
    }
}
