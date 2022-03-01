//
//  LoginService.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/19.
//

import Foundation
import Moya

enum LoginService{
    case login(LoginRequest)
    case signup(SignupRequest)
}

extension LoginService: TargetType {
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/signin"
        case .signup:
            return "/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .login,
             .signup:
            return .post
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .signup(let param):
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

