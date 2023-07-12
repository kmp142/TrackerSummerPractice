//
//  OtherSpecificationsTableViewCellDelegate.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

protocol OtherSpecificationsTableViewCellDelegate: AnyObject {
    func textFieldDidChange(cell: OtherSpecificationsTableViewCell, text: String)
}
