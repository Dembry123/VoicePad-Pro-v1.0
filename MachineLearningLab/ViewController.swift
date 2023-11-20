//
//  ViewController.swift
//  MachineLearningLab
//
//  Created by Duke Bartholomew on 11/15/23.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {
    
    let SERVER_URL = "http://10.8.144.46:8000"
    
    // MARK: Class Properties
    lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 8.0
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        return URLSession(configuration: sessionConfig,
            delegate: self,
            delegateQueue:self.operationQueue)
    }()
    let operationQueue = OperationQueue()


    @IBOutlet weak var goodbyeButton: UIButton!
    @IBOutlet weak var adiosButton: UIButton!
    @IBOutlet weak var sayonaraButton: UIButton!
    @IBOutlet weak var aurevoirButton: UIButton!
    @IBOutlet weak var ciaoButton: UIButton!
    @IBOutlet weak var microphoneImage: UIImageView!
    
    
    struct AudioConstants{
        static let AUDIO_BUFFER_SIZE = 1024*4
    }
    // setup audio model
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a tap gesture recognizer for the microphoneImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            tapGestureRecognizer.numberOfTouchesRequired = 1
            microphoneImage.isUserInteractionEnabled = true
            microphoneImage.addGestureRecognizer(tapGestureRecognizer)

        // Add targets for the button events
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        self.adiosButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.adiosButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        self.sayonaraButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.sayonaraButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        self.aurevoirButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.aurevoirButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        self.ciaoButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.ciaoButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        
        let baseURL = "\(SERVER_URL)/Handlers"

        if let url = URL(string: baseURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response or error here
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw Response: \(jsonString)")
                    } else {
                        print("Unable to convert data to UTF-8 string")
                    }
                }

            }

            dataTask.resume() // Start the task
        } else {
            print("Invalid URL")
        }

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: view)
            if microphoneImage.frame.contains(touchPoint) {
                // Touch down on the microphoneImage, change color to red
                microphoneImage.tintColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 1.0)
            }
        }
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        // Button is being held down (touch down), change background color to red
        //set up audio model
        self.audio.play()
        self.audio.startMicrophoneProcessing(withFps: 20) // preferred number of FFT calculations per second
        self.audio.setupAudioPlayer()
        
        print("ON \(sender.titleLabel?.text ?? "")")
    }
    
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        // Button is released (touch up), change background color back to normal
        print("OFF \(sender.titleLabel?.text ?? "")")
        self.audio.pause()
        self.audio.printFFT()
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .began {
            // Touch down, change color to red
            microphoneImage.tintColor = UIColor.red
        } else if sender.state == .ended {
            // Touch up, change color to blue
            microphoneImage.tintColor = UIColor.link
        }
    }
    
    
    
}
