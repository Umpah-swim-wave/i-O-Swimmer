//
//  LoginStorage.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/19.
//

import Foundation
import Moya

final class LoginStorage {
    
    // MARK: - Shared
    
    static let shared: LoginStorage = LoginStorage()
    
    // MARK: - Network
    
    private let authProvider = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    // MARK: - POST /auth/signup
    func dispatchSignUp(nickname: String,
                        phone: String,
                        completion: @escaping (() -> ())) {
        let param = SignupRequest(nickname: "최다인", phone: "01012345678")
        
        self.authProvider.request(.signup(param)) { response in
            switch response{
            case .success(let result):
                do{
                    print(result)
                    completion()
                }catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
}
