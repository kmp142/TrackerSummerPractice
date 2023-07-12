//
//  AddNewProductViewController.swift
//  Project
//
//  Created by Mac on 2023-07-07.
//

import UIKit

/// юзер добавляет новый продукт в список продуктов
final class AddNewProductViewController : BaseViewController {
    
    @IBOutlet weak var writeDataAboutProductNavigationBar: UINavigationBar!
    @IBOutlet weak var writeNameLabel: UILabel!
    @IBOutlet weak var nameOfNewProductTextField: UITextField!
    @IBOutlet weak var caloriesTableView: UITableView!
    @IBOutlet weak var otherSpecificationsTableView: UITableView!
    @IBOutlet weak var addNewProductScrollView: UIScrollView!
    @IBOutlet weak var writeCalloriesLabel: UILabel!
    @IBOutlet weak var writeOtherLabel: UILabel!
    @IBOutlet weak var addNewProductButton: UIButton!
    weak var delegate: FindFoodViewControllerDelegate?
    
    /// юзается потом для обновления FindFoodViewController
    private var product: Product = Product(name: "", calories: 34, fats: 5, proteins: 6, carbohydrates: 7, other: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewForTable(caloriesTableView)
        setViewForTable(otherSpecificationsTableView)
        
        // установка делегатов ячеек таблиц
        for cell in caloriesTableView.visibleCells {
            if let textFieldCell = cell as? CalloriesTableViewCell {
                textFieldCell.numberOfCaloriesTextField.delegate = self
            }
        }
        for cell in otherSpecificationsTableView.visibleCells {
            if let textFieldCell = cell as? OtherSpecificationsTableViewCell {
                textFieldCell.numberOfOtherSpecificationTextField.delegate = self
            }
        }
        
        // установка размеров элементов страницы для скроллинга
        writeDataAboutProductNavigationBar.frame = CGRect(x: 0, y: 0, width: addNewProductScrollView.frame.width, height: 44)
        writeNameLabel.frame = CGRect(x: 30, y: 60, width: 225, height: 30)
        nameOfNewProductTextField.frame = CGRect(x: 30, y: 100, width: 335, height: 34)
        writeCalloriesLabel.frame = CGRect(x: 30, y: 155, width: 225, height: 30)
        caloriesTableView.frame = CGRect(x: 30, y: 190, width: 335, height: 240)
        writeOtherLabel.frame = CGRect(x: 30, y: 450, width: 335, height: 30)
        otherSpecificationsTableView.frame = CGRect(x: 30, y: 485, width: 335, height: 720)
        addNewProductButton.frame = CGRect(x: 259, y: 1215, width: 110, height: 45)

        // размеры скроллера
        addNewProductScrollView.contentSize = CGSize(width: addNewProductScrollView.frame.width, height: 1315)
        
        // добавление элементов в скроллер
        addNewProductScrollView.addSubview(writeDataAboutProductNavigationBar)
        addNewProductScrollView.addSubview(writeNameLabel)
        addNewProductScrollView.addSubview(nameOfNewProductTextField)
        addNewProductScrollView.addSubview(writeCalloriesLabel)
        addNewProductScrollView.addSubview(caloriesTableView)
        addNewProductScrollView.addSubview(otherSpecificationsTableView)
        addNewProductScrollView.addSubview(addNewProductButton)
    }
    
    private func setViewForTable (_ table: UITableView) {
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 10
        table.isScrollEnabled = false
        nameOfNewProductTextField.delegate = self
    }
    
    private func tellAboutMistake () {
        writeDataAboutProductNavigationBar.topItem?.title = "Неверные данные"
        writeDataAboutProductNavigationBar.barTintColor = .systemRed
    }
    
    private func createTextField () -> UITextField {
        let textField = UITextField()
        return textField
    }
    
    private lazy var dataWithCaloriesProperties : [Property] = [
        Property(type: "Жиры", textField: createTextField()),
        Property(type: "Белки", textField: createTextField()),
        Property(type: "Углеводы", textField: createTextField())
    ]
    
    private lazy var dataWithOtherSpecificationsProperties : [Property] = [
        Property(type: "Содержание воды", textField: createTextField()),
        Property(type: "Пищевые волокна", textField: createTextField()),
        Property(type: "Витамин A", textField: createTextField()),
        Property(type: "Витамин B1", textField: createTextField()),
        Property(type: "Витамин B9", textField: createTextField()),
        Property(type: "Витамин B12", textField: createTextField()),
        Property(type: "Витамин D", textField: createTextField()),
        Property(type: "Витамин E", textField: createTextField()),
        Property(type: "Витамин C", textField: createTextField())
    ]
}

/// всё, что связано с таблицами
extension AddNewProductViewController : UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    /// клава пропадает при нажатии ретёрна
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    /// количество ячеек в зависимости от таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case caloriesTableView:
            return dataWithCaloriesProperties.count
        case otherSpecificationsTableView:
            return dataWithOtherSpecificationsProperties.count
        default:
            return 0
        }
    }
    
    /// наполнение ячейки в зависимости от таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case caloriesTableView: do {
            
            guard let cell = caloriesTableView.dequeueReusableCell(withIdentifier: "CalloriesTableViewCell") as? CalloriesTableViewCell else { return UITableViewCell() }
            
            let property = dataWithCaloriesProperties[indexPath.row]
            
            cell.numberOfCaloriesTextField.tag = indexPath.row
            cell.numberOfCaloriesTextField.delegate = self
            
            cell.setUpForCalloriesTable(property)
            
            return cell
        }
        case otherSpecificationsTableView: do {
            
            guard let cell = otherSpecificationsTableView.dequeueReusableCell(withIdentifier: "OtherSpecificationsTableViewCell") as? OtherSpecificationsTableViewCell else { return UITableViewCell() }
            
            let property = dataWithOtherSpecificationsProperties[indexPath.row]
            
            cell.numberOfOtherSpecificationTextField.tag = indexPath.row + 3
            cell.numberOfOtherSpecificationTextField.delegate = self
            
            cell.setUpForOtherSpecificationsTable(property)
            
            return cell
        }
        default:
            return UITableViewCell()
        }
    }
    
    /// текстовое поле закончено редактироваться, изменение данных
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChanged(textField)
    }
}

/// всё, что связано с получением данных от юзера и добавлением их в FindFoodViewController
extension AddNewProductViewController {
    
    /// инициализирует продукт из юзерской даты и добавляет его в таблицу из FindFoodViewController
    @IBAction func addNewProductButton(_ sender: Any){
        
        guard let name = nameOfNewProductTextField.text, !name.isEmpty else {
            tellAboutMistake()
            return
        }
        product.name = name
    
        delegate?.update(newProduct: product)
        dismiss(animated: true, completion: nil)
    }
    
    /// проверяет, что конвертированное значение != nil
    func checkValue (_ string: String?) -> Bool {
        if fromStringToDouble(string) != nil { return true }
        else { return false }
    }
    
    /// из стринга в дабл + проверка на >= 0
    func fromStringToDouble (_ string: String?) -> Double? {
        if let doubleValue = Double(string ?? "-1"), doubleValue >= 0 {
            return doubleValue
        } else {
            return nil
        }
    }
    
    /// меняет значение продукта на пришедшие
    func valueChanged(_ textField: UITextField){
        let text = textField.text
        if checkValue(text) {
            switch textField.tag {
            case 0:
                product.fats = fromStringToDouble(text) ?? -1
            case 1:
                product.proteins = fromStringToDouble(text) ?? -1
            case 2:
                product.carbohydrates = fromStringToDouble(text) ?? -1
            case 3...:
                let index = fromTextFieldTagToName(textField.tag)
                product.other?[index] = fromStringToDouble(text!)
            default:
                tellAboutMistake()
            }
        }
    }
    
    /// конвертит из тэга в имя свойства
    func fromTextFieldTagToName (_ tag : Int) -> String {
        let index = tag - 3
        return dataWithOtherSpecificationsProperties[index].type
    }
}
