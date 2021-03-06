//
//  EntityContext.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

// the different categories of entity we are viewing
enum EntityContext: Int {
    case characters
    case vehicles
    case starships
}

// all values extension, we will use this to populate our table view driven menu
extension EntityContext {
    static var allValues: [EntityContext] = [.characters, .vehicles, .starships]
}

// descriptions
extension EntityContext: CustomStringConvertible {
    var description: String {
        switch self {
        case .characters:
            return "Characters"
        case .vehicles:
            return "Vehicles"
        case .starships:
            return "Starships"
        }
    }
}


