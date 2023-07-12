//
//  DiaryViewControllerDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-10.
//

import UIKit

/// делегат для передачи инфы из AddFoodViewController в DiaryViewController
protocol DiaryViewControllerDelegate : AnyObject {
    func update(newMeal: Meal)
}
