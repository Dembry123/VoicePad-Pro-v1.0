//
//  ServerModel.swift
//  MachineLearningLab
//
//  Created by Dylan Embry on 11/20/23.
//

import Foundation

class ServerModel {
    
    let SERVER_URL = "http://10.8.153.54:8000"
    var accuracyLabel = ""
    var predictionLabel = ""

    func sendPostRequest(fftData: [Float], languageLabel: String) {
        let baseURL = "\(SERVER_URL)/AddDataPoint"
        
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dsid = 0 // Replace with actual dsid value if necessary

        let postData: [String: Any] = [
            "feature": fftData,
            "label": languageLabel,
            "dsid": dsid
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Error: Unable to serialize JSON data")
            return
        }

        request.httpBody = jsonData

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
            } else {
                print("Unable to convert data to UTF-8 string")
            }
        }

        dataTask.resume() // Start the task
    }

    func sendPredictionRequest(fftData: [Float], completion: @escaping (String) -> Void){
        let baseURL = "\(SERVER_URL)/PredictOne" // Replace '/upload' with the correct endpoint

        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dsid = 0 // Replace with actual dsid value if necessary

        let postData: [String: Any] = [
            "feature": fftData,
            "dsid": dsid
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Error: Unable to serialize JSON data")
            return
        }

        request.httpBody = jsonData

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
                completion(jsonString)
            } else {
                print("Unable to convert data to UTF-8 string")
            }
        }

        dataTask.resume() // Start the task
    }

//    func trainModels(){
//        let baseURL = "\(SERVER_URL)/UpdateModel" // Append dsid as a query parameter
//
//        guard let url = URL(string: baseURL) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response: \(jsonString)")
//                self.accuracyLabel = jsonString
//            } else {
//                print("Unable to convert data to UTF-8 string")
//            }
//        }
//
//        dataTask.resume() // Start the task
//    }
//    
    func trainModels(completion: @escaping (String) -> Void){
        let baseURL = "\(SERVER_URL)/UpdateModel" // Append dsid as a query parameter

        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
                completion(jsonString)
            } else {
                print("Unable to convert data to UTF-8 string")
            }
        }

        dataTask.resume() // Start the task
    }
    
}
