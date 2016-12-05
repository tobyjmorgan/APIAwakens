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
    case people(PersonID?)
    case vehicles(VehicleID?)
    case starships(StarshipID?)
    case planets(PlanetID?)
    case manual(SWAPIURLString)
}

extension StarWarsAPIUseCase: APIUseCase {
    var baseURL: String {
        
        return "https://swapi.co/api/"
    }
    
    var path: String {

        switch self {

        case .people(let id):
            if let id = id {
                return "people/\(id)/"
            }
            
            return "people/"
            
        case .vehicles(let id):
            if let id = id {
                return "vehicles/\(id)/"
            }
            
            return "vehicles/"
            
        case .starships(let id):
            if let id = id {
                return "starships/\(id)/"
            }
            
            return "starships/"
            
        case .planets(let id):
            if let id = id {
                return "planets/\(id)/"
            }
            
            return "planets/"
        
        case .manual(let urlString):
            let url = URL(string: urlString)!
            let lastPathComponent = url.lastPathComponent
            let query = url.query!
            
            return "\(lastPathComponent)/?\(query)"
        }
    }
}

struct ResultsPage {
    let nextPageURLString: String?
    let results: [JSON]
}

extension StarWarsAPIUseCase {
    
    func getParser() -> (JSON) -> ResultsPage? {
        
        switch self {
        case .people(let id), .vehicles(let id), .starships(let id), .planets(let id):
            return { json in
                
                if id != nil {
                    return ResultsPage(nextPageURLString: nil, results: [json])
                } else {
                    if let arrayOfItems = json["results"] as? [JSON] {
                        let page = ResultsPage(nextPageURLString: json["next"] as? String, results: arrayOfItems)
                        return page
                    } else {
                        return nil
                    }
                }
            }
            
        case .manual:
            return { json in
                if let arrayOfItems = json["results"] as? [JSON] {
                    let page = ResultsPage(nextPageURLString: json["next"] as? String, results: arrayOfItems)
                    return page
                } else {
                    return nil
                }
            }
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
