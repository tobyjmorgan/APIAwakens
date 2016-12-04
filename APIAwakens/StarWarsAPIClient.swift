//
//  StarWarsAPIClient.swift
//  TheAPIAwakens
//
//  Created by redBred LLC on 11/29/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

typealias PersonID = Int
typealias VehicleID = Int
typealias StarshipID = Int
typealias PlanetID = Int
typealias SWAPIURLString = String

enum StarWarsAPIUseCase {
    case allPeople
    case allVehicles
    case allStarships
    case allPlanets
    case person(PersonID)
    case vehicle(VehicleID)
    case starship(StarshipID)
    case planet(PlanetID)
//    case manual(SWAPIURLString)
}

extension StarWarsAPIUseCase: APIUseCase {
    var baseURL: URL {
        return URL(string: "https://swapi.co/api/")!
    }
    
    var path: String {

        switch self {

        case .allPeople:
            return "people/"
            
        case .allVehicles:
            return "vehicles/"
            
        case .allStarships:
            return "starships/"
            
        case .allPlanets:
            return "planets/"
            
        case .person(let id):
            return "people/\(id)/"
            
        case .vehicle(let id):
            return "vehicles/\(id)/"
            
        case .starship(let id):
            return "starships/\(id)/"
            
        case .planet(let id):
            return "planets/\(id)"
        }
    }
}

final class StarWarsAPIClient: APIClient {
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(config: URLSessionConfiguration) {
        self.configuration = config
    }
    
    convenience init() {
        self.init(config: URLSessionConfiguration.default)
    }
}
