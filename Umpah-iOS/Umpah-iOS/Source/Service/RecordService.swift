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
}

extension RecordService: TargetType{
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sendSwimmingRecord:
            return "/record"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .sendSwimmingRecord:
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
