//
//  ContentKey.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

// all the JSON keys we will be using in the SWAPI
enum ContentKey: String {
    case birth_year
    case eye_color
    case hair_color
    case height
    case homeworld
    case name
    case cost_in_credits
    case crew
    case length
    case manufacturer
    case vehicle_class
    case starship_class
    
    // this is a special case - not actually a JSON key, but will
    // be used for the derived attribute: asscoiated vehicles and starships
    case associatedVehicles
}

// descriptions (will appear in our DetailViewController's table view)
extension ContentKey: CustomStringConvertible {
    var description: String {
        switch self {
        case .birth_year:
            return "Born"
        case .eye_color:
            return "Eyes"
        case .hair_color:
            return "Hair"
        case .height:
            return "Height"
        case .homeworld:
            return "Home"
        case .name:
            return "Name"
        case .cost_in_credits:
            return "Cost"
        case .crew:
            return "Crew"
        case .length:
            return "Length"
        case .manufacturer:
            return "Make"
        case .vehicle_class, .starship_class:
            return "Class"
        case .associatedVehicles:
            return "Assoc. Vehicles"
        }
    }
}

// the content keys associated with each entity context
extension EntityContext {
    var associatedKeys: [ContentKey] {
        switch self {
        case .characters:
            return [.birth_year, .homeworld, .height, .eye_color, .hair_color, .associatedVehicles]
        case .vehicles:
            return [.manufacturer, .cost_in_credits, .length, .vehicle_class, .crew]
        case .starships:
            return [.manufacturer, .cost_in_credits, .length, .starship_class, .crew]
        }
    }
}
