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
    
    private let authPlugin = AccessTokenPlugin { _ in GeneralAPI.token }
    private lazy var authProvider = MoyaProvider<RecordService>(plugins: [authPlugin, NetworkLoggerPlugin(verbose: true)])
    
    public private(set) var dayRecordLabsLists: [RecordLabsList] = []
    
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
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /dayRecord/list
    func fetchDayRecord(date: String,
                        completion: @escaping (() -> ())) {
        let query = DayRecordRequest(date: date)
        
        self.authProvider.request(.askDayRecord(query: query)) { response in
            switch response {
            case .success(let result):
                do{
                    let dayRecordModel = try result.map(DayRecordModel.self)
                    self.dayRecordLabsLists = dayRecordModel.data.recordLabsList
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /weekRecord/list
    func fetchWeekRecord(date: String,
                         week: Int,
                         stroke: String? = nil,
                         completion: @escaping (() -> ())) {
        self.authProvider.request(.askWeekRecord(date: date, week: week, stroke: stroke)) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /monthRecord/list
    func fetchMonthRecord(date: String,
                          stroke: String? = nil,
                          completion: @escaping (() -> ())) {
        self.authProvider.request(.askMonthRecord(date: date, stroke: stroke)) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /dayRecord/recent-record-date/list
    func fetchUserDayRecord(completion: @escaping (() -> ())) {
        self.authProvider.request(.userDayRecord) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /weekRecord/recent-record-date/list
    func fetchUserWeekRecord(completion: @escaping (() -> ())) {
        self.authProvider.request(.userWeekRecord) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
    
    // MARK: - GET /monthRecord/recent-record-date/list
    func fetchUserMonthRecord(completion: @escaping (() -> ())) {
        self.authProvider.request(.userMonthRecord) { response in
            switch response {
            case .success(let result):
                do{
                    print(result)
                    completion()
                } catch(let err){
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
                print("와 실패다!")
            }
        }
    }
}
