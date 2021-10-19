//
//  Date+.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/15.
//

import Foundation

extension Date{
//
//    func toKoreaTime() -> Date {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
//        return Date()
//    }
//
    func toKoreaTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let localTime = formatter.string(from: self)
        
        return localTime
    }
}
