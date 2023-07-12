//
//  CalloriesTableViewCellDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

protocol CalloriesTableViewCellDelegate: AnyObject {
    func textFieldDidChange(cell: CalloriesTableViewCell, text: String)
}
