//
//  NewViewController.swift
//  Project
//
//  Created by Dmitry on 11.07.2023.
//

import UIKit

class NewViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = "100 мл - это примерно 6 столовых ложек\n\n250мл - до краев заполненный граненый стакан\n\n500 мл - бутылка средних размеров"
        
    }
}
