//
//  ServerModel.swift
//  MachineLearningLab
//
//  Created by Dylan Embry on 11/20/23.
//

import Foundation

class ServerModel {
    
    // Base URL of the server
    let SERVER_URL = "http://10.8.153.54:8000"
    
    // Variables to store the accuracy and prediction labels
    var accuracyLabel = ""
    var predictionLabel = ""

    // Function to send FFT data and language label to server for adding a data point
    func sendPostRequest(fftData: [Float], languageLabel: String) {
        let baseURL = "\(SERVER_URL)/AddDataPoint"
        
        // Ensure the URL is valid
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Replace dsid with the actual dataset id value as needed
        let dsid = 0

        // Prepare the post data
        let postData: [String: Any] = [
            "feature": fftData,
            "label": languageLabel,
            "dsid": dsid
        ]

        // Serialize the data into JSON format
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Error: Unable to serialize JSON data")
            return
        }

        request.httpBody = jsonData

        // Create and start the data task
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Handle the response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
            } else {
                print("Unable to convert data to UTF-8 string")
            }
        }

        dataTask.resume() // Start the task
    }

    // Function to send FFT data for making a prediction
    func sendPredictionRequest(fftData: [Float], completion: @escaping (String) -> Void){
        let baseURL = "\(SERVER_URL)/PredictOne"

        // Ensure the URL is valid
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Replace dsid with the actual dataset id value as needed
        let dsid = 0

        // Prepare the post data
        let postData: [String: Any] = [
            "feature": fftData,
            "dsid": dsid
        ]

        // Serialize the data into JSON format
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Error: Unable to serialize JSON data")
            return
        }

        request.httpBody = jsonData

        // Create and start the data task
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Handle the response and execute completion handler
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
                completion(jsonString)
            } else {
                print("Unable to convert data to UTF-8 string")
            }
        }

        dataTask.resume() // Start the task
    }

    // Function to initiate the model training on the server and handle the response
    func trainModels(completion: @escaping (String) -> Void){
        let baseURL = "\(SERVER_URL)/UpdateModel" 

        // Ensure the URL is valid
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Create and start the data task
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Handle the response and execute completion handler
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
                completion(jsonString)
            } else {
                print("Unable to convert data to UTF")
            }

         }
        dataTask.resume() // Start the task
    }
}