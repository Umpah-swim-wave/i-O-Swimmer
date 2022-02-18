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
    case askDayRecord(query: CommonRecordRequest)
    case askWeekRecord(query: WeekRecordRequest)
    case askMonthRecord(query: CommonRecordRequest)
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
        case .askMonthRecord:
            return "/monthRecord/list"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .sendSwimmingRecord:
            return .post
        case .askDayRecord,
             .askWeekRecord,
             .askMonthRecord:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .sendSwimmingRecord(let param):
            return .requestJSONEncodable(param)
        case .askDayRecord(let query):
            return .requestParameters(parameters: try! query.asDictionary(), encoding: URLEncoding.default)
        case .askWeekRecord(let query):
            return .requestParameters(parameters: try! query.asDictionary(), encoding: URLEncoding.default)
        case .askMonthRecord(let query):
            return .requestParameters(parameters: try! query.asDictionary(), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
