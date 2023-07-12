//
//  FindProductTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-07.
//

import UIKit

final class FindProductTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameOfProductLabel : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameOfProductLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
