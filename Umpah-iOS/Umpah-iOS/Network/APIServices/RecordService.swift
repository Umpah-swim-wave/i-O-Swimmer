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
    case askDayRecord(query: DayRecordRequest)
    case askWeekRecord(date: String, week: Int, stroke: String?)
    case askMonthRecord(date: String, stroke: String?)
    case userDayRecord
    case userWeekRecord
    case userMonthRecord
}

extension RecordService: TargetType, AccessTokenAuthorizable {
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
        case .userDayRecord:
            return "/dayRecord/recent-record-date/list"
        case .userWeekRecord:
            return "/weekRecord/recent-record-date/list"
        case .userMonthRecord:
            return "/monthRecord/recent-record-date/list"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .sendSwimmingRecord:
            return .post
        case .askDayRecord,
             .askWeekRecord,
             .askMonthRecord,
             .userDayRecord,
             .userWeekRecord,
             .userMonthRecord:
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
        case .askWeekRecord(let date, let week, let stroke):
            if let stroke = stroke {
                return .requestParameters(parameters: ["date" : date, "week" : week, "stroke": stroke], encoding: URLEncoding.default)
            }
            return .requestParameters(parameters: ["date" : date, "week" : week], encoding: URLEncoding.default)
        case .askMonthRecord(let date, let stroke):
            if let stroke = stroke {
                return .requestParameters(parameters: ["date" : date, "stroke": stroke], encoding: URLEncoding.default)
            }
            return .requestParameters(parameters: ["date" : date], encoding: URLEncoding.default)
        case .userDayRecord:
            return .requestPlain
        case .userWeekRecord:
            return .requestPlain
        case .userMonthRecord:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .sendSwimmingRecord,
             .askDayRecord,
             .askWeekRecord,
             .askMonthRecord,
             .userDayRecord,
             .userWeekRecord,
             .userMonthRecord:
            return .bearer
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
