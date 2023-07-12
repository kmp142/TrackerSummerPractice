//
//  OtherSpecificationsTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

final class OtherSpecificationsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var otherSpecificationLabel: UILabel!
    @IBOutlet weak var numberOfOtherSpecificationTextField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// устанавливается из FindFoodViewController
    func setUpForOtherSpecificationsTable (_ otherSpecifications: Property) {
        otherSpecificationLabel.text = otherSpecifications.type
        numberOfOtherSpecificationTextField = otherSpecifications.textField
        numberOfOtherSpecificationTextField.delegate = self
    }
}

extension OtherSpecificationsTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
