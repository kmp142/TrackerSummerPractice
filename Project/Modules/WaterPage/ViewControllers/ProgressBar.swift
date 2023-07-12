//
//  ProgressBar.swift
//  Project
//
//  Created by Dmitry on 07.07.2023.
//

import UIKit
import ALProgressView

class MyViewController: UIViewController {

    private lazy var progressRing = ALProgressRing()
    private lazy var progressBar = ALProgressBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(progressRing)
        view.addSubview(progressRing)
      
          // MARK: ALProgressRing
        
        // Setup layout
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
          // Make sure to set the view size
        progressRing.widthAnchor.constraint(equalToConstant: 180).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 180).isActive = true
      
      
        // MARK: ALProgressBar
      
        // Setup layout
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 20).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //progressBar.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        // Make sure to set the view height
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
      
       
        // Setting progress
        progressRing.setProgress(0.8, animated: true)
        progressBar.setProgress(0.6, animated: true)
    }
}
