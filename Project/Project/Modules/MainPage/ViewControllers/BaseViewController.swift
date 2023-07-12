//
//  BaseViewController.swift
//  Project
//
//  Created by Mac on 2023-07-12.
//

import UIKit

/// позволяет всем наследникам добавить жест: нажатие на экран -> скрытие клавы
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// обработчик жестов
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
