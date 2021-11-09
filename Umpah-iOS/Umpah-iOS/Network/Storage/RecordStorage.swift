//
//  RecordStorage.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/11/09.
//

import Foundation
import Moya

final class RecordStorage {
    
    // MARK: - Shared
    
    static let shared: RecordStorage = RecordStorage()
    
    // MARK: - Network
    
    private let authProvider = MoyaProvider<RecordService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    // MARK: - POST /record
    func dispatchRecord(workoutList: [SwimmingWorkoutData],
                        completion: @escaping (() -> ())) {
        let param = SwimmingRecordRequest(userID: 1,
                                          workoutList: workoutList)
        
        self.authProvider.request(.sendSwimmingRecord(param: param)) { response in
            switch response{
            case .success(let result):
                do{
                    print(result)
                    let responseData = try result.map(CommonResponse.self)
                    print("-----------response-----------")
                    print(responseData)
                    print("------------------------------")
                    completion()
                }catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion()
            }
        }
    }
    
    // MARK: - POST /dayRecord/list
    func dispatchDayRecord(date: String,
                           stroke: String,
                           completion: @escaping (() -> ())) {
        let param = CommonRecordRequest(date, stroke)
        
        self.authProvider.request(.askDayRecord(param: param)) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    let responseData = try result.map(CommonResponse.self)
                    print("-----------response-----------")
                    print(responseData)
                    print("------------------------------")
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion()
            }
        }
    }
    
    // MARK: - POST /weekRecord/list
    func dispatchWeekRecord(startDate: String,
                            endDate: String,
                            stroke: String,
                            completion: @escaping (() -> ())) {
        let param = WeekRecordRequest(startDate, endDate, stroke)
        
        self.authProvider.request(.askWeekRecord(param: param)) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    let responseData = try result.map(CommonResponse.self)
                    print("-----------response-----------")
                    print(responseData)
                    print("------------------------------")
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion()
            }
        }
    }
    
    // MARK: - POST /monthRecord/list
    func dispatchMonthRecord(date: String,
                           stroke: String,
                           completion: @escaping (() -> ())) {
        let param = CommonRecordRequest(date, stroke)
        
        self.authProvider.request(.askMonthRecord(param: param)) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    let responseData = try result.map(CommonResponse.self)
                    print("-----------response-----------")
                    print(responseData)
                    print("------------------------------")
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion()
            }
        }
    }
}
