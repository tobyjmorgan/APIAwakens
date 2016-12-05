//
//  EntityContext.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

enum EntityContext: Int {
    case characters
    case vehicles
    case starships
}

extension EntityContext {
    static var allValues: [EntityContext] = [.characters, .vehicles, .starships]
}

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

extension EntityContext {
    var useCase: StarWarsAPIUseCase {
        switch self {
        case .characters:
            return .people(nil)
        case .vehicles:
            return .vehicles(nil)
        case .starships:
            return .starships(nil)
        }
    }
}

