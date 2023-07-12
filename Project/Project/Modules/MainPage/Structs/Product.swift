//
//  Product.swift
//  Project
//
//  Created by Mac on 2023-07-12.
//

import UIKit

struct Product : Codable, Equatable {
    var name : String
    var calories : Double
    var fats : Double
    var proteins : Double
    var carbohydrates : Double
    var other : [String: Double]?
}
