//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Vibhor Gupta on 7/31/17.
//  Copyright © 2017 Vibhor Gupta. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController ,  AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordedAudio : RecordedAudio!
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // check_record_permission()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
        stopButton.isHidden = true
        recordingInProgress.isHidden = true
    }
    
//    func check_record_permission()
//    {
//        switch AVAudioSession.sharedInstance().recordPermission() {
//        case AVAudioSessionRecordPermission.granted:
//            isAudioRecordingGranted = true
//            break
//        case AVAudioSessionRecordPermission.denied:
//            isAudioRecordingGranted = false
//            break
//        case AVAudioSessionRecordPermission.undetermined:
//            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.isAudioRecordingGranted = true
//                    } else {
//                        self.isAudioRecordingGranted = false
//                    }
//                }
//            }
//            break
//        default:
//            break
//        }
//    }


    @IBAction func recordAudio(_ sender: UIButton) {
        stopButton.isHidden = false
        recordingInProgress.isHidden = false
        print("Record Audio")

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let pathArray =  [dirPath,recordingName]
        let stringPathArray = String(describing: pathArray)
        let filePath = NSURL.fileURL(withPath: stringPathArray)
        print(filePath)
        
        //Setup audio Session
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        }catch let error as NSError {
            print("Error : \(error) ")
        }
        do {
        //IniTialise and Prepare The Recorder
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
       
        audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        }catch let error as NSError {
            print(error)
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //TODO: save the  recorded audio
        if(flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url as NSURL
        recordedAudio.title = recorder.url.lastPathComponent
        
        //Move to next Scene to perform segue
        self.performSegue(withIdentifier:
            "stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
  
    @IBAction func stopAudio(_ sender: UIButton) {
        recordingInProgress.isHidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try   audioSession.setActive(false)
            
        }catch let error as NSError {
            print("Error : \(error)")
        }
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC : PlaySoundViewController = segue.destination as! PlaySoundViewController
            let data = sender as!  RecordedAudio
            playSoundVC.recievedAudio = data
        }
    }
    
}

