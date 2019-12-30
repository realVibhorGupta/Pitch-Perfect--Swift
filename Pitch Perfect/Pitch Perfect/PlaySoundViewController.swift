//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Vibhor Gupta on 8/1/17.
//  Copyright © 2017 Vibhor Gupta. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var audioPlayer : AVAudioPlayer!
    
    var recievedAudio : RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // Do any additional setup after loading the view.
        
        
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: recievedAudio.filePathUrl as URL)
            audioPlayer.enableRate  = true
            audioEngine = AVAudioEngine()
        }catch let error as NSError {
            print(error)
        }
        
        do{
            audioFile = try AVAudioFile(forReading: recievedAudio.filePathUrl as URL)

        }catch let error as NSError{
            print(error)
        }
    }
    
    
    @IBAction func playSlowAudio(_ sender: UIButton) {
        playAudioWithVariableSpeed(speed: 0.5)
    }
    
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        playAudioWithVariableSpeed(speed: 1.5)
    }
    
    
    
    
    @IBAction func roboticAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(pitch: -1000)
        
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton) {
        
        audioPlayer.stop()
    }
    
    @IBAction func chipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1000)
    }
    
    func playAudioWithVariableSpeed(speed : Float){
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    func playAudioWithVariablePitch(pitch  :Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioNode()
        audioEngine.attach(audioPlayerNode)
        
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
       // audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        
    }
}

