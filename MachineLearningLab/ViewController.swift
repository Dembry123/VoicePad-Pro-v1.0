//
//  ViewController.swift
//  MachineLearningLab
//
//  Created by Duke Bartholomew on 11/15/23.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {
    
    // MARK: Class Properties
    
    // Create a URLSession with custom configuration and delegate
    lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 8.0
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        return URLSession(configuration: sessionConfig,
                          delegate: self,
                          delegateQueue: self.operationQueue)
    }()
    
    // Create an operation queue for handling URLSession delegate methods
    let operationQueue = OperationQueue()
    
    // Connect buttons from the Interface Builder
    @IBOutlet weak var goodbyeButton: UIButton!
    @IBOutlet weak var adiosButton: UIButton!
    @IBOutlet weak var sayonaraButton: UIButton!
    @IBOutlet weak var aurevoirButton: UIButton!
    @IBOutlet weak var ciaoButton: UIButton!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var bothModelPredictions: UILabel!
    @IBOutlet weak var finalPrediction: UILabel!
    @IBOutlet weak var predictButton: UIButton!
    
    // Constants for audio buffer size
    struct AudioConstants{
        static let AUDIO_BUFFER_SIZE = 1024*4
    }
    
    // Create an instance of the AudioModel class
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE)
    
    // Create an instance of the ServerModel class
    let server = ServerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add targets for button events
        
        // Set up touch down and touch up events for the "Goodbye" button
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        // Set up touch down and touch up events for the "Adios" button
        self.adiosButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.adiosButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        // Set up touch down and touch up events for the "Sayonara" button
        self.sayonaraButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.sayonaraButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        // Set up touch down and touch up events for the "Aurevoir" button
        self.aurevoirButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.aurevoirButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        // Set up touch down and touch up events for the "Ciao" button
        self.ciaoButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.ciaoButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        // Set up touch down and touch up events for the "Predict" button
        self.predictButton.addTarget(self, action: #selector(predicitonButtonTouchDown), for: .touchDown)
        self.predictButton.addTarget(self, action: #selector(predictButtonTouchUp), for: .touchUpInside)
        
        // Set up touch down event for the "Train" button
        self.trainButton.addTarget(self, action: #selector(trainButtonTouchDown), for: .touchDown)
    }
    
    // Function to handle the touch down event for the "Train" button
    @objc func trainButtonTouchDown(_ sender: UIButton){
        self.server.trainModels { [weak self] accuracy in
            DispatchQueue.main.async {
                // Replace commas with newlines
                let formattedAccuracy = accuracy.replacingOccurrences(of: ",", with: "\n")
                
                // Create a substring excluding the first and last character
                let startIndex = formattedAccuracy.index(formattedAccuracy.startIndex, offsetBy: 1)
                let endIndex = formattedAccuracy.index(formattedAccuracy.endIndex, offsetBy: -1)
                let trimmedAccuracy = String(formattedAccuracy[startIndex..<endIndex])
                
                self?.bothModelPredictions.text = trimmedAccuracy
            }
        }
    }
    
    // Function to handle the touch down event for the buttons
    @objc func buttonTouchDown(_ sender: UIButton) {
        // Button is being held down (touch down), change background color to red
        // Set up audio model
        self.audio.play()
        self.audio.startMicrophoneProcessing(withFps: 20) // preferred number of FFT calculations per second
        print("ON \(sender.titleLabel?.text ?? "")")
    }
    
    // Function to handle the touch up event for the buttons
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        // Button is released (touch up), change background color back to normal
        print("OFF \(sender.titleLabel?.text ?? "")")
        self.audio.pause()
        self.server.sendPostRequest(fftData: self.audio.fftData, languageLabel: sender.titleLabel?.text ?? "")
    }
    
    // Function to handle the touch down event for the "Predict" button
    @objc func predicitonButtonTouchDown(_ sender: UIButton) {
        // Button is being held down (touch down), change background color to red
        // Set up audio model
        self.audio.play()
        self.audio.startMicrophoneProcessing(withFps: 20) // preferred number of FFT calculations per second
        self.finalPrediction.text = "Listening..."
        print("ON \(sender.titleLabel?.text ?? "")")
    }
    
    // Function to handle the touch up event for the "Predict" button
    @objc func predictButtonTouchUp(_ sender: UIButton){
        self.server.sendPredictionRequest(fftData: self.audio.fftData) { [weak self] finalPrediction in
            DispatchQueue.main.async {
                let startIndex = finalPrediction.index(finalPrediction.startIndex, offsetBy: 2)
                let endIndex = finalPrediction.index(finalPrediction.endIndex, offsetBy: -2)
                let trimmedPrediction = String(finalPrediction[startIndex..<endIndex])
                
                self?.finalPrediction.text = trimmedPrediction
            }
        }
    }
}

