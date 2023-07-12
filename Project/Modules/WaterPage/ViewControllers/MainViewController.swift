//
//  MainViewController.swift
//  Project
//
//  Created by Dmitry on 05.07.2023.
//

import UIKit

import ALProgressView

class MainViewController: UIViewController {
    
    @IBOutlet weak var waterAmountLabel: UILabel!
    private let userDefaults = UserDefaults.standard
    private let progressRing = ALProgressRing()
    private var actions: [Float] = []
    private var dailyWaterAmount = 2000
    private let waterAmountLabelKey = "waterAmountLabelKey"
    private let progressAmountKey = "progressAmountKey"
    private let actionsKey = "actionsKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressRing)
        
        //Fill stored data
        waterAmountLabel.text = userDefaults.string(forKey: "waterAmountLabelKey")
        progressRing.setProgress(userDefaults.float(forKey: progressAmountKey), animated: true)
        let emptyArray: [Float] = []
        actions = userDefaults.array(forKey: actionsKey)?.compactMap{ $0 as? Float ?? 0} ?? emptyArray
        
        //Ring layout
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        //Ring height & width
        progressRing.widthAnchor.constraint(equalToConstant: 300).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Ring other settings
        progressRing.lineWidth = 50
        progressRing.duration = 3
        progressRing.startColor = .systemPink
        progressRing.endColor = .systemCyan
        progressRing.grooveColor = .systemGray6
    }
    
    @IBAction func buttonForAdd100ml(_ sender: Any) {
        if progressRing.progress + 0.1 < 1.1 {
            let value = progressRing.progress
            let coefficient = 0.1*1000/Float(dailyWaterAmount)
            progressRing.setProgress(Float(progressRing.progress)+coefficient, animated: true)
            waterAmountLabel.text = "\(Int(Float(progressRing.progress)*Float(dailyWaterAmount)))/\(dailyWaterAmount)"
            actions.append(Float(progressRing.progress) - Float(value))
            userDefaults.set(waterAmountLabel.text, forKey: waterAmountLabelKey)
            userDefaults.set(Float(progressRing.progress), forKey: progressAmountKey)
            userDefaults.set(actions, forKey: "actionsKey")
        } else { return }
        
        
    }
    
    @IBAction func buttonForAdd250ml(_ sender: Any) {
        if progressRing.progress + 0.25 < 1.25 {
            let value = progressRing.progress
            let coefficient = 0.25*1000/Float(dailyWaterAmount)
            progressRing.setProgress(Float(progressRing.progress)+coefficient, animated: true)
            waterAmountLabel.text = "\(Int(Float(progressRing.progress)*Float(dailyWaterAmount)))/\(dailyWaterAmount)"
            actions.append(Float(progressRing.progress) - Float(value))
            userDefaults.set(waterAmountLabel.text, forKey: waterAmountLabelKey)
            userDefaults.set(Float(progressRing.progress), forKey: progressAmountKey)
            userDefaults.set(actions, forKey: "actionsKey")
        } else { return }
    }
    
    @IBAction func buttonForAdd500ml(_ sender: Any) {
        if progressRing.progress + 0.5 < 1.5 {
            let value = progressRing.progress
            let coefficient = 0.5*1000/Float(dailyWaterAmount)
            progressRing.setProgress(Float(progressRing.progress)+coefficient, animated: true)
            waterAmountLabel.text = "\(Int(Float(progressRing.progress)*Float(dailyWaterAmount)))/\(dailyWaterAmount)"
            actions.append(Float(progressRing.progress) - Float(value))
            userDefaults.set(waterAmountLabel.text, forKey: waterAmountLabelKey)
            userDefaults.set(Float(progressRing.progress), forKey: progressAmountKey)
            userDefaults.set(actions, forKey: actionsKey)
        } else { return }
    }
    
    @IBAction func buttonForCancelLastAdd (_ sender: Any) {
        if !actions.isEmpty {
            progressRing.setProgress(Float(progressRing.progress) - (actions.last ?? 0), animated: true)
            waterAmountLabel.text = "\(Int(Float(progressRing.progress)*Float(dailyWaterAmount)))/\(dailyWaterAmount)"
            actions.removeLast()
            userDefaults.set(waterAmountLabel.text, forKey: waterAmountLabelKey)
            userDefaults.set(Float(progressRing.progress), forKey: progressAmountKey)
            userDefaults.set(actions, forKey: actionsKey)
        }
        else { return }
    }
    @IBAction func infoButton(_ sender: Any) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "NewViewController") as? NewViewController else {
            return
        }
        present(viewController, animated: true)
    }
}

