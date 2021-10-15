//
//  HealthKitSetupAssistant.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/15.
//

import Foundation
import HealthKit

class HealthKitSetupAssistant{
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    static func authorizeHealthKitAtSwimming(completion: @escaping (Bool, Error?) -> Void){
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard   let distanceSwimming = HKObjectType.quantityType(forIdentifier: .distanceSwimming),
                let swimStroke = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let basalEnergy = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
                let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
                let bodyTemparature = HKObjectType.quantityType(forIdentifier: .bodyTemperature),
                let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
        else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [distanceSwimming,
                                                       swimStroke,
                                                       activeEnergy,
                                                       basalEnergy,
                                                       exerciseTime,
                                                       heartRate,
                                                       bodyTemparature,
                                                       dateOfBirth,
                                                       biologicalSex,
                                                       HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: nil,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
