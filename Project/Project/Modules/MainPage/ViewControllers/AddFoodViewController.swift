//
//  AddFoodViewController.swift
//  Project
//
//  Created by Mac on 2023-07-07.
//

import UIKit

final class AddFoodViewController : BaseViewController {
    
    @IBOutlet weak var nameOfMealNavigationItem: UINavigationItem!
    @IBOutlet weak var nameOfProductLabel: UILabel!
    @IBOutlet weak var countOfCalloriesLabel: UILabel!
    @IBOutlet weak var calloriesLabel: UILabel!
    @IBOutlet weak var numberOfСarbohydratesLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var numberOfProteinsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var numberOfFatsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var writeNumberOfProductLabel: UILabel!
    @IBOutlet weak var numberOfProductTextField: UITextField!
    @IBOutlet weak var funnyImageView: UIImageView!
    @IBOutlet weak var otherSpecitificationsTableView: UITableView!
    
    var initialTextFromUser: String?
    weak var delegate: DiaryViewControllerDelegate?
    
    /// массив с данными для ячеек, устанавливается set-е экрана
    private var dataWitnOthers: [Other] = [
        Other(name: "Содержание воды", amount: 0),
        Other(name: "Пищевые волокна", amount: 0),
        Other(name: "Витамин A", amount: 0),
        Other(name: "Витамин B1", amount: 0),
        Other(name: "Витамин B9", amount: 0),
        Other(name: "Витамин B12", amount: 0),
        Other(name: "Витамин D", amount: 0),
        Other(name: "Витамин E", amount: 0),
        Other(name: "Витамин C", amount: 0)
    ]

    /// кнопка для добавления
    @IBAction func addProductInMealButton(_ sender: Any) {
        addProduct()
    }
    
    /// добавляет продукт в съеденные в массив userMeals в DiaryViewController с помощью delegate
    private func addProduct() {
        
        let product = Product(name: nameOfProductLabel.text ?? "name", calories: Double(countOfCalloriesLabel.text ?? "-1") ?? -1, fats: Double(numberOfFatsLabel.text ?? "-1") ?? -1, proteins: Double(numberOfProteinsLabel.text ?? "-1") ?? -1, carbohydrates: Double(numberOfСarbohydratesLabel.text ?? "-1") ?? -1)
        
        let meal = Meal(name: nameOfMealNavigationItem.title ?? "name", eatenProducts: [product])
        
        delegate?.update(newMeal: meal)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// загружает вид контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funnyImageView.layer.zPosition = -1 // Задний план
        nameOfProductLabel.layer.zPosition = 1 // Передний план
        
        numberOfProductTextField.delegate = self
        
        otherSpecitificationsTableView.dataSource = self
        otherSpecitificationsTableView.delegate = self
        otherSpecitificationsTableView.layer.cornerRadius = 10
        
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    /// устанавливает значения для AddFoodViewController
    func setInfoForAddFoodViewController (meal: String, product: Product) {
        nameOfMealNavigationItem.title = meal
        nameOfProductLabel.text = product.name
        numberOfСarbohydratesLabel.text = round(product.carbohydrates)
        numberOfFatsLabel.text = round(product.fats)
        numberOfProteinsLabel.text = round(product.proteins)
        countOfCalloriesLabel.text = round(countCaloriesFromBJU(carbohydrates: product.carbohydrates, fats: product.fats, proteins: product.proteins))
        fromProductToOtherArray(product)
    }
    
    /// меняет значения в dataWitnOthers, если в product есть значения у соотв-х свойств
    private func fromProductToOtherArray (_ product: Product) {
        
        guard let others = product.other, !others.isEmpty else { return }
        
        for other in others {
            if other.value != 0 {
                for index in dataWitnOthers.indices {
                    if dataWitnOthers[index].name == other.key {
                        dataWitnOthers[index].amount = other.value
                    }
                }
            }
        }
    }
    
    /// округление + конверт в Double
    private func round (_ number: Double) -> String {
        let roundedNumber = (number * 100).rounded() / 100
        let formattedNumber = String(format: "%.2f", roundedNumber)
        return formattedNumber
    }
    
    /// считает норму ккал из БЖУ
    func countCaloriesFromBJU (carbohydrates: Double, fats: Double, proteins: Double) -> Double {
        var calories: Double = 0
        calories += carbohydrates * 4
        calories += fats * 9
        calories += proteins * 4
        
        return calories
    }
}

extension AddFoodViewController : UITextFieldDelegate {
    
    /// сохранение значения, которое ввёл юзер
    func textFieldDidBeginEditing(_ textField: UITextField) {
        initialTextFromUser = textField.text
    }
    
    /// от нажатия return пропадает клавиатура + продукт добавляется с помощью addProduct()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addProduct()
        return true
    }
    
    /// изменение textField-ов со старыми граммами на новые после того, как юзер закончил редачить
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let calories = fromStringToDouble(countOfCalloriesLabel.text ?? "-1")
        let carbohydrates = fromStringToDouble(numberOfСarbohydratesLabel.text ?? "-1")
        let proteins = fromStringToDouble(numberOfProteinsLabel.text ?? "-1")
        let fats = fromStringToDouble(numberOfFatsLabel.text ?? "-1")
        
        let oldGramm = fromStringToDouble(initialTextFromUser ?? "-1")
        
        let nowGram = Double(textField.text ?? "-1")
        
        // замена значений старых граммовок на новые
        countOfCalloriesLabel.text = changeCalories(previousG: oldGramm, previousCalorie: calories, nowG: nowGram ?? -1)
        numberOfСarbohydratesLabel.text = changeCalories(previousG: oldGramm, previousCalorie: carbohydrates, nowG: nowGram ?? -1)
        numberOfProteinsLabel.text = changeCalories(previousG: oldGramm, previousCalorie: proteins, nowG: nowGram ?? -1)
        numberOfFatsLabel.text = changeCalories(previousG: oldGramm, previousCalorie: fats, nowG: nowGram ?? -1)
    }
    
    /// конверт функция + округление
    private func fromStringToDouble(_ string: String) -> Double {
        let result : Double = Double(string) ?? -1
        return Double(round(result)) ?? -1
    }
    
    /// меняет значения со старыми граммами на значения с новыми
    private func changeCalories (previousG: Double, previousCalorie: Double, nowG: Double) -> String {
        let result = nowG * previousCalorie / previousG
        return round(result)
    }
}

extension AddFoodViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataWitnOthers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        43
    }
    
    /// возвращает ячеку ShowOtherTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = otherSpecitificationsTableView.dequeueReusableCell(withIdentifier: "ShowOtherTableViewCell") as? ShowOtherTableViewCell else { return UITableViewCell() }

        cell.setUpForOtherSpecificationsTable(dataWitnOthers[indexPath.row])
        
        return cell
    }
}
