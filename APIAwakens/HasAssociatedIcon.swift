//
//  HasAssociatedIcon.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation
import UIKit

protocol HasAssociatedIcon {
    var icon: UIImage { get }
}

extension EntityContext: HasAssociatedIcon {
    var icon: UIImage {
        switch self {
        case .characters:
            return UIImage(named: "icon-characters")!
        case .vehicles:
            return UIImage(named: "icon-vehicles")!
        case .starships:
            return UIImage(named: "icon-starships")!
        }
    }
}
