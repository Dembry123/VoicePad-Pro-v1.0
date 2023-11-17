//
//  ViewController.swift
//  MachineLearningLab
//
//  Created by Duke Bartholomew on 11/15/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var goodbyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.goodbyeButton.backgroundColor = UIColor.clear

        // Add targets for the button events
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.goodbyeButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
            
    }
    
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        // Button is being held down (touch down), change background color to red
        sender.backgroundColor = UIColor.red
    }

    @objc func buttonTouchUpInside(_ sender: UIButton) {
        // Button is released (touch up), change background color back to normal
        sender.backgroundColor = UIColor.clear // Set it to your default background color
    }

    
    @IBAction func goodbyeTrain(_ sender: UIButton) {
    

    }
    
    
    @IBAction func adiosTrain(_ sender: Any) {
    }
    

    @IBAction func sayonaraTrain(_ sender: Any) {
    }
    
    
    @IBAction func aurevoirTrain(_ sender: Any) {
    }
    
    
    @IBAction func ciaoTrain(_ sender: Any) {
    }
}

