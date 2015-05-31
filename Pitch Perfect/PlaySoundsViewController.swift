//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Keith Bertram on 5/17/15.
//  Copyright (c) 2015 Keith Bertram. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var m_audioPlayer:AVAudioPlayer!
    var m_receivedAudio:RecordedAudio!
    var m_audioEngine:AVAudioEngine!
    var m_audioFile:AVAudioFile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        var error:NSError?
        m_audioPlayer = AVAudioPlayer(contentsOfURL: m_receivedAudio.filePathUrl, error: &error)
        m_audioPlayer.enableRate = true
        m_audioPlayer.prepareToPlay()
        
        m_audioEngine = AVAudioEngine()
        m_audioFile = AVAudioFile(forReading: m_receivedAudio.filePathUrl, error: nil)

    }

    func PlaySound (rate: Float)
    {
        m_audioEngine.stop()
        m_audioEngine.reset()
        
        m_audioPlayer.stop ()
        m_audioPlayer.rate = rate;
        m_audioPlayer.currentTime = 0.0
        m_audioPlayer.play()
        
    }
    
    @IBAction func StopPlay(sender: UIButton)
    {
        m_audioPlayer.stop ()
        m_audioEngine.stop()
        m_audioEngine.reset()
    }
    
    @IBAction func PlayChipmunkAudio(sender: UIButton)
    {
        playAudioWithPitch (1000)
    }
    
    @IBAction func PlayFast(sender: UIButton)
    {
            PlaySound (1.5)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayDarthvaderAudio(sender: AnyObject)
    {
        playAudioWithPitch (-1000)
    }
    
    @IBAction func PlaySlow(sender: UIButton)
    {
        PlaySound (0.5)
    }

    func playAudioWithPitch(pitch: Float)
    {
        m_audioPlayer.stop()
        m_audioEngine.stop()
        m_audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        m_audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        m_audioEngine.attachNode(changePitchEffect)
        
        m_audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        m_audioEngine.connect(changePitchEffect, to: m_audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(m_audioFile, atTime: nil, completionHandler: nil)
        m_audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
