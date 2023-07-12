//
//  WelcomeViewController.swift.swift
//  Project
//
//  Created by Mac on 2023-07-11.
//

import UIKit

struct User : Codable {
    var height: Int
    var weight: Int
    var age: Int
    var sex: String
    var aim: Aim
}

enum Aim : String, Codable {
    case looseWeight = "Скинуть вес"
    case gainWeight = "Набрать вес"
    case dryBody = "Подсушиться"
}

/// пользователь вводит данные о себе, которые сохраняются в UserDefaults
final class WelcomeViewController : BaseViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var SexSegmentControl: UISegmentedControl!
    @IBOutlet weak var aimPickerView: UIPickerView!
    weak var delegate: DiaryViewControllerWithWelcomeDelegate?
    
    private let data = [Aim.dryBody, Aim.gainWeight, Aim.looseWeight]
    
    /// пользователь с UserDefaults
    var user: User{
        get {
            if let data = defaults.value(forKey: "user") as? Data{
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else { return User(height: 0, weight: 0, age: 0, sex: "", aim: .dryBody)}
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                defaults.set(data, forKey: "user")
            }
        }
    }
    
    /// обновляет введённые юзером данные на DiaryViewController
    @IBAction func startButton(_ sender: Any) {
        
        // установка юзерских данных
        if checkValue(heightTextField) && checkValue(weightTextField) && checkValue(ageTextField) {
            user.age = Int(ageTextField.text!) ?? 0
            user.height = Int(heightTextField.text!) ?? 0
            user.weight = Int(weightTextField.text!) ?? 0
        } else { return }
        segmentedControlValueChanged(SexSegmentControl)
        
        delegate?.update(user: user)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        aimPickerView.delegate = self
        aimPickerView.dataSource = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        ageTextField.delegate = self
    }
    
    /// проверяет на nil и "" ретёрнит бул
    private func checkValue(_ string: UITextField) -> Bool {
        if string.text != nil && string.text != "" { return true }
        else { return false }
    }
    
    /// устанавливает пол из SegmentControl
    private func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        if selectedIndex == 0 {
            user.sex = "Мужчина"
        } else if selectedIndex == 1 {
            user.sex = "Женщина"
        }
    }
}

/// работа с PickerView
extension WelcomeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].rawValue
    }
    
    /// возвращается имя ячейки при нажатии
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        user.aim = data[row]
    }
}

extension WelcomeViewController: UITextFieldDelegate {
    
    /// клава прячется от ретёрна
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
