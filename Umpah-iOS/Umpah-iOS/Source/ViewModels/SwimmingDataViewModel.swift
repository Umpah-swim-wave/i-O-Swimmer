//
//  SwimmingDataViewModel.swift
//  Umpah-iOS
//
//  Created by 장혜령 on 2021/10/16.
//

import Foundation
import CSV

class SwimmingDataViewModel{
    let swimmingStorage = SwimmingDataStorage()
    var swimmingWorkoutList: [SwimWorkoutData] = []
    
    func initSwimmingData(){
        swimmingStorage.loadWorkoutHKSource()
        swimmingStorage.refineSwimmingWorkoutData(completion: { workoutList, error in
            self.swimmingWorkoutList = workoutList
            self.getStrokeAndDistanceData()
        })
    }
    
    private func getStrokeAndDistanceData(){
        for index in 0..<swimmingWorkoutList.count {
            swimmingStorage.refineSwimmingStrokeData(start: swimmingWorkoutList[index].startDate,
                                                     end:  swimmingWorkoutList[index].endDate) { strokes, error in
                self.swimmingWorkoutList[index].strokeList = strokes
            }
            swimmingStorage.refineSwimmingDistanceData(start: swimmingWorkoutList[index].startDate,
                                                       end: swimmingWorkoutList[index].endDate) { distances, error in
                self.swimmingWorkoutList[index].distanceList = distances
            }
        }
    }
    
    private func makeSwimmingDateToCSVFile(){
        let documentURL = setNewCSVFile(fileName: "swimmingDetailData.csv")
        print("-----------------------")
        print(documentURL)
        print("-----------------------")
        
        let stream = OutputStream(url: documentURL , append: true)!
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: ["시작시간", "종료시간", "운동시간", "style번호"])
        
        for workout in swimmingWorkoutList {
            for index in 0..<workout.distanceList.count{
                var rowData: [String] = []
                rowData.append(workout.distanceList[index].startDate.toKoreaTime())
                rowData.append(workout.distanceList[index].endDate.toKoreaTime())
                rowData.append(workout.distanceList[index].timeInterval.description)
                rowData.append(workout.strokeList[index].strokeStyle.description)
                try! csv.write(row: rowData)
            }
            try! csv.write(row: ["------","------","------","------"])
        }
        
    }
    
    func setNewCSVFile(fileName: String) -> URL{
        //fileManager 이용
        //core data 도 함께
        print(NSHomeDirectory())
        let fileManager = FileManager.default // 파일 매니저의 싱글톤 객체 리턴
        
        // document dir url
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let myText = NSString(string:"")

        //빈파일로 다시 만들기
        try? myText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        return fileURL
        
    }
    
}
