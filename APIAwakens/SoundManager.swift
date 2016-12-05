//
//  SoundManager.swift
//  AmusementParkPart1
//
//  Created by redBred LLC on 11/16/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundManager {
    
    enum Notifications: String {
        case notificationPlayCharacterSound
        case notificationPlayVehicleSound
        case notificationPlayStarshipSound
        case notificationPlayAlertSound
    }
    
    // sounds
    var characterSound: SystemSoundID = 0
    var vehicleSound: SystemSoundID = 0
    var starshipSound: SystemSoundID = 0
    var alertSound: SystemSoundID = 0
    
    init() {
        loadSounds()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playCharacterSound), name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayCharacterSound.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playVehicleSound), name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayVehicleSound.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playStarshipSound), name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayStarshipSound.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playAlertSound), name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayAlertSound.rawValue), object: nil)
    }
    
    // load the specified sound
    func loadSound(filename: String, systemSound: inout SystemSoundID) {
        
        if let pathToSoundFile = Bundle.main.path(forResource: filename, ofType: "wav") {
            
            let soundURL = URL(fileURLWithPath: pathToSoundFile)
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &systemSound)
        }
    }
    
    // load all needed sounds
    func loadSounds() {
        
        loadSound(filename: "character", systemSound: &characterSound)
        loadSound(filename: "vehicle", systemSound: &vehicleSound)
        loadSound(filename: "starship", systemSound: &starshipSound)
        loadSound(filename: "Alert", systemSound: &alertSound)
    }
    
    @objc func playCharacterSound() {
        AudioServicesPlaySystemSound(characterSound)
    }
    
    @objc func playVehicleSound() {
        AudioServicesPlaySystemSound(vehicleSound)
    }

    @objc func playStarshipSound() {
        AudioServicesPlaySystemSound(starshipSound)
    }

    @objc func playAlertSound() {
        AudioServicesPlaySystemSound(alertSound)
    }
}
