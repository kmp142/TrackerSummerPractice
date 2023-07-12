//
//  InformationAboutMealTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

final class InformationAboutMealTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameOfeatenProductLabel: UILabel!
    @IBOutlet weak var numberCalloriesOfProductLabel: UILabel!
    
    func setUpForMealTable (_ product: Product) {
        nameOfeatenProductLabel.text = product.name
        numberCalloriesOfProductLabel.text = String(product.calories)
    }
}
