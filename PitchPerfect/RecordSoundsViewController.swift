//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alessandro Malhotra on 03/08/2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // This is our audio recorder
    var audioRecorder: AVAudioRecorder!
    
    // MARK: IB Outlets
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // Loads the root view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
    }
    
    func isRecording(_ recording: Bool) {
        // switch statement based on true and false then
        
        switch recording {
        
        case true:
            recordLabel.text = "Recording in progress"
            stopRecordButton.isEnabled = true
            recordButton.isEnabled = false
        
        case false:
            recordButton.isEnabled = true
            stopRecordButton.isEnabled = false
            recordLabel.text = "Tap To Record"
    
        }
    }

    // MARK: IB Action Record Button
    
    @IBAction func recordAudio(_ sender: Any) {
        isRecording(true)

        // Gets the directory path for the application
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        // MARK: Direct Path for audio file
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator:"/"))
        
        // MARK: Audio Session Set Up
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        
        // Creates Audio recorder with path and starts Recording
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        // Informs audio recorder RSVC can act as its delegate
        
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // MARK: IB Action Stop Button
    
    @IBAction func stopRecording(_ sender: Any) {
        isRecording(false)
        
        // Recording and Session Stopped
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Segue Perfromed
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording not successfull.")
        }
    }
    
    // Second view controller prepared for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Verifies correct identifier
        
        if segue.identifier == "stopRecording" {
            
            // Grabs destination for VC and the Sender
            
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

