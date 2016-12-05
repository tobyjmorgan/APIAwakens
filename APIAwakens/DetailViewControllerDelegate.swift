//
//  DetailViewControllerDelegate.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import Foundation

// a delegate for anyone calling the DetailViewController to conform to
protocol DetailViewControllerDelegate {
    var currentEntityContext: EntityContext? { get }
}
