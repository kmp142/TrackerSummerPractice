//
//  FindFoodViewControllerDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-10.
//

import UIKit

/// делегат для обновления таблицы FindFoodViewController из AddNewProductViewController
protocol FindFoodViewControllerDelegate : AnyObject {
    func update(newProduct: Product)
}
