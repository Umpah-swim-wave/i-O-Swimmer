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
    
    // MARK: - GET /dayRecord/list
    func fetchDayRecord(date: String,
                        stroke: String,
                        completion: @escaping (() -> ())) {
        let query = CommonRecordRequest(date: date, stroke: stroke)
        
        self.authProvider.request(.askDayRecord(query: query)) { response in
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
    
    // MARK: - GET /weekRecord/list
    func fetchWeekRecord(startDate: String,
                         endDate: String,
                         stroke: String,
                         completion: @escaping (() -> ())) {
        let query = WeekRecordRequest(startDate: startDate, endDate: endDate, stroke: stroke)
        
        self.authProvider.request(.askWeekRecord(query: query)) { response in
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
    
    // MARK: - GET /monthRecord/list
    func fetchMonthRecord(date: String,
                          stroke: String,
                          completion: @escaping (() -> ())) {
        let query = CommonRecordRequest(date: date, stroke: stroke)
        
        self.authProvider.request(.askMonthRecord(query: query)) { response in
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
