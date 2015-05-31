//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Keith Bertram on 5/9/15.
//  Copyright (c) 2015 Keith Bertram. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var m_audioRecorder:AVAudioRecorder!
    var m_recordedAudio:RecordedAudio!
    
    @IBOutlet var RecordingLabel: UILabel!
    
    @IBOutlet var StopButton: UIButton!
    @IBOutlet var RecordingButton: UIButton!
    @IBOutlet var ClickToRecordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(Bool)
    {
        StopButton.hidden = true;
        ClickToRecordLabel.hidden = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func OnRecordAudio(sender: UIButton) {
        ClickToRecordLabel.hidden = true;
        RecordingLabel.hidden = false;
        StopButton.hidden = false;
        RecordingButton.enabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        m_audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        m_audioRecorder.delegate = self
        m_audioRecorder.meteringEnabled = true
        m_audioRecorder.prepareToRecord()
        m_audioRecorder.record()

    }

    
    
    @IBAction func StopPressed(sender: UIButton) {
        RecordingLabel.hidden = true;
        StopButton.hidden = true;
        RecordingButton.enabled = true;
        
        m_audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StopRecording")
        {
            let PlaySoundsVC:PlaySoundsViewController   = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            PlaySoundsVC.m_receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag)
        {
        m_recordedAudio = RecordedAudio()
        
        m_recordedAudio.initVars ()
            
        m_recordedAudio.filePathUrl = recorder.url
        m_recordedAudio.title = recorder.url.lastPathComponent
        self.performSegueWithIdentifier("StopRecording", sender: m_recordedAudio)
        }
        else
        {
            println ("Recording was not successful")
            RecordingButton.enabled = true
            StopButton.hidden = true
        }
        }
    
}

