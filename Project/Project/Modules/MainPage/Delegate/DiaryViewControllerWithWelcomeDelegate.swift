//
//  DiaryViewControllerWithWelcomeDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-12.
//

import UIKit

/// делегат для передачи инфы из WelcomeViewController в DiaryViewController
protocol DiaryViewControllerWithWelcomeDelegate : AnyObject {
    func update(user: User)
}
