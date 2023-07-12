//
//  ShowOtherTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-12.
//

import UIKit

final class ShowOtherTableViewCell : UITableViewCell {
    
    @IBOutlet weak var otherNameLabel: UILabel!
    @IBOutlet weak var numberOfOtherSpecificationLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// установка значений для элементов таблицы otherSpecitificationsTableView из AddFoodViewController
    func setUpForOtherSpecificationsTable (_ other : Other) {
        otherNameLabel.text = other.name
        numberOfOtherSpecificationLabel.text = String(other.amount)
    }
}
