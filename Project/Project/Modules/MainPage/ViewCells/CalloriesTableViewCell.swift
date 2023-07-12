//
//  CalloriesTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

final class CalloriesTableViewCell : UITableViewCell {
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesTextField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// устанавливается из FindFoodViewController
    func setUpForCalloriesTable (_ calories: Property) {
        caloriesLabel.text = calories.type
        numberOfCaloriesTextField = calories.textField
        numberOfCaloriesTextField.delegate = self
    }
}

extension CalloriesTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

