//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Winston Churchill Bowen Jr on 12/7/17.
//  Copyright © 2017 codeWarrior928. All rights reserved.
//

// Mark: Imports

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // Mark: Member variables
    
    var audioRecorder: AVAudioRecorder!
    
    // Mark: Outlets
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // Mark: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(playState: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Mark: Recording
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        configureUI(playState: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not succesful")
        }
    }
    
    
    // Mark: Transitioning between controllers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // Mark: Configuring UI
    
    func configureUI(playState: Bool) {
        if(playState) {
            enableRecordButton()
        } else {
            disableRecordingButton()
        }
    }
    
    func enableRecordButton() {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }
    
    func disableRecordingButton() {
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
    }

}

