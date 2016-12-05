//
//  CanPlaySound.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/4/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

protocol CanPlaySound {
    func playSound()
}

extension EntityContext: CanPlaySound {
    func playSound() {
        switch self {
        case .characters:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayCharacterSound.rawValue), object: nil)
        case .vehicles:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayVehicleSound.rawValue), object: nil)
        case .starships:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayStarshipSound.rawValue), object: nil)
        }
    }
}
