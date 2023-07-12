//
//  DiaryControllerSecondDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-11.
//

import UIKit

protocol DiaryControllerSecondDelegate: AnyObject {
    func update(age: Int, sex: String, aim: Aim, height: Int, weight: Int)
}
