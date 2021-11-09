//
//  RecordService.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/26.
//

import Foundation
import Moya

enum RecordService{
    case sendSwimmingRecord(param: SwimmingRecordRequest)
    case askDayRecord(param: DayRecordRequest)
    case askWeekRecord(param: WeekRecordRequest)
}

extension RecordService: TargetType{
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sendSwimmingRecord:
            return "/record"
        case .askDayRecord:
            return "/dayRecord/list"
        case .askWeekRecord:
            return "/weekRecord/list"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .sendSwimmingRecord,
             .askDayRecord,
             .askWeekRecord:
            return .post
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .sendSwimmingRecord(let param):
            return .requestJSONEncodable(param)
        case .askDayRecord(let param):
            return .requestJSONEncodable(param)
        case .askWeekRecord(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
