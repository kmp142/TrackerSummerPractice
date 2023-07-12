//
//  Meal.swift
//  Project
//
//  Created by Mac on 2023-07-12.
//

import UIKit

struct Meal : Codable {
    let name : String
    var eatenProducts: [Product]?
}
