//
//  RecordedSound.swift
//  Pitch Perfect
//
//  Created by Keith Bertram on 5/21/15.
//  Copyright (c) 2015 Keith Bertram. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    func initVars ()
    {
    let filePathUrl = NSURL (string: "")
    title = "Pitch Perfect"
    }
}