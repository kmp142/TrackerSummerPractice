//
//  DiaryViewController.swift
//  Project
//
//  Created by Mac on 2023-07-06.
//

import UIKit
import Charts

final class DiaryViewController : UIViewController {
    
    private let defaults = UserDefaults.standard
    
    @IBOutlet weak var healthAdviceLabel: UILabel!
    @IBOutlet weak var mealsTableView : UITableView!
    private var pieChart = PieChartView()
    
    private let welcomeViewController = WelcomeViewController()
    private var age = 0
    private var sex = ""
    private var aim = ""
    private var height = 0
    private var weight = 0
    
    /// сохранение в UserDefaults
    var userMeals: [Meal] {
        get {
            if let data = defaults.value(forKey: "meals") as? Data {
                return try! PropertyListDecoder().decode([Meal].self, from: data)
            } else { return [Meal]() }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "meals")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// при нажатии на центр диаграммы открывается WelcomeViewController
        let tapInCyrcleOfChar = UITapGestureRecognizer(target: self, action: #selector(handlePieChartTap))
        pieChart.addGestureRecognizer(tapInCyrcleOfChar)
        pieChart.delegate = self
        
        welcomeViewController.delegate = self
        
        setUserData ()
        setMealsTable()
        customHealtLabel()
        
        // таймер
        let timer = Timer(fire: Date(), interval: 24 * 60 * 60, repeats: true) { timer in
            self.clearUserDefaultsDaily()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func handlePieChartTap() {
        performSegue(withIdentifier: "WelcomeViewController", sender: self)
    }
    
    private func setUserData () {
        userMeals += userMealsExample
        age = welcomeViewController.user.age
        sex = welcomeViewController.user.sex
        aim = welcomeViewController.user.aim.rawValue
        height = welcomeViewController.user.height
        weight = welcomeViewController.user.weight
    }
    
    private func setMealsTable () {
        mealsTableView.dataSource = self
        mealsTableView.delegate = self
        mealsTableView.layer.cornerRadius = 10
    }
    
    private func customHealtLabel () {
        healthAdviceLabel.layer.cornerRadius = 10
        healthAdviceLabel.layer.masksToBounds = true
        healthAdviceLabel.backgroundColor = UIColor(red: 0.27, green: 0.37, blue: 0.52, alpha: 1.0)
        healthAdviceLabel.text = dataWithHealthyAdvice.randomElement()
    }
    
    /// для добавления в userMeals для наличия там названий приёмов пищи
    private let  userMealsExample: [Meal] = [
        Meal(name: "Завтрак", eatenProducts: nil),
        Meal(name: "Обед", eatenProducts: nil),
        Meal(name: "Ужин", eatenProducts: nil),
        Meal(name: "Перекус", eatenProducts: nil)
    ]
    
    /// массив для таблицы, которая на экране
    private lazy var dataWithMeals : [Meal] = [
        Meal(name: "Завтрак", eatenProducts: nil),
        Meal(name: "Обед", eatenProducts: nil),
        Meal(name: "Ужин", eatenProducts: nil),
        Meal(name: "Перекус", eatenProducts: nil)
    ]
    
    private var dataWithHealthyAdvice: [String] = [
        "Пейте достаточно воды для увлажнения организма.",
        "Увеличьте потребление свежих фруктов и овощей.",
        "Ограничьте сахар и соль в своем рационе.",
        "Выбирайте натуральные продукты вместо обработанных.",
        "Контролируйте размеры порций для умеренного питания.",
        "Отказывайтесь от сладких напитков и фастфуда.",
        "Умеренность и баланс - ключ к здоровому питанию.",
        "Заменяйте ненатуральные продукты на здоровые альтернативы."
    ]
    
    /// чистит приёмы пищи по таймеру
    private func clearUserDefaultsDaily() {
        if let lastClearDate = defaults.object(forKey: "LastClearDate") as? Date {
            if Date().timeIntervalSince(lastClearDate) >= 24 * 60 * 60 {
                defaults.removeObject(forKey: "meals")
                defaults.set(Date(), forKey: "LastClearDate")
            }
        } else {
            defaults.set(Date(), forKey: "LastClearDate")
        }
    }
}

// всё, что связано с таблицей приёмов пищи
extension DiaryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        59
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataWithMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = mealsTableView.dequeueReusableCell(withIdentifier: "MealsTableViewCell") as? MealsTableViewCell else { return UITableViewCell() }
        
        cell.navigationController = navigationController
        cell.viewController = self
        
        let meal = dataWithMeals[indexPath.row]
        
        cell.setUpForMealsTable(meal)
        cell.addFoodButton?.tag = indexPath.row // тэг для каждой кнопки
        
        return cell
    }
    
    /// если ячейка выбрана, показывается модально InformationAboutMealViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = userMeals[indexPath.row]

        guard let informationAboutMealViewController = storyboard?.instantiateViewController(withIdentifier: "InformationAboutMealViewController") as? InformationAboutMealViewController else { return }
        
        informationAboutMealViewController.loadViewIfNeeded()
        
        informationAboutMealViewController.setUpInformationAboutMeal(meal: meal)
        
        present(informationAboutMealViewController, animated: true)
    }
}

// всё, что касается делегатов
extension DiaryViewController : DiaryViewControllerDelegate, DiaryViewControllerWithWelcomeDelegate {
    /// в зависимости от того, что приходит, назначается делегат
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? AddFoodViewController {
            destination.delegate = self
        } else if let destination = segue.destination as? WelcomeViewController {
            destination.delegate = self
        } else { return }
    }
    
    /// обновляет данные юзера из WelcomeViewController
    func update(user: User) {
        welcomeViewController.user = user
        viewDidLayoutSubviews()
        viewDidLoad()
    }
    
    /// обновляет дату с приёмами пищи из AddFoodViewController
    func update(newMeal: Meal) {
        var index = 0
        
        switch newMeal.name {
        case "Завтрак":
            index = 0
        case "Обед":
            index = 1
        case "Ужин":
            index = 2
        case "Перекус":
            index = 3
        default:
            index = 0
        }
        
        // если нет ничего по этому приёму пищи, то создаётся новый объект
        if userMeals[index].eatenProducts == nil {
            userMeals[index].eatenProducts = newMeal.eatenProducts
            viewDidLayoutSubviews()
        }
        else {
            userMeals[index].eatenProducts! += newMeal.eatenProducts ?? [Product(name: "", calories: -1, fats: -1, proteins: -1, carbohydrates: -1)]
            viewDidLayoutSubviews()
        }
    }
}

// всё, что касается диаграммы
extension DiaryViewController : ChartViewDelegate {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        getDataForChart()
        getViewOfChart()
        getTextOfTitleOfChart()
        
        view.addSubview(pieChart)
        
        /// данные для диаграммы
        func getDataForChart () {
            var dataEntries = [PieChartDataEntry]()
            var isSomethingIn = false
            
            for meal in userMeals {
                if ((meal.eatenProducts?.count) != nil) {
                    isSomethingIn = true
                }
            }
            
            // если есть какая-то еда в съеденном, то вид диаграммы меняется, иначе - текст в диаграмме = "Добавьте еду"
            if isSomethingIn {
                for meal in userMeals {
                    let entry = PieChartDataEntry(value: countCaloriesOfMeal(meal), label: meal.name)
                    dataEntries.append(entry)
                }
            }
            else {
                let entry = PieChartDataEntry(value: Double(countNormalCalories()), label: "Добавьте еду")
                dataEntries.append(entry)
            }
            
            let dataSet = PieChartDataSet(entries: dataEntries)
            let data = PieChartData(dataSet: dataSet)
            pieChart.data = data
            dataSet.colors = ChartColorTemplates.pastel()
        }
        
        /// вид диаграммы
        func getViewOfChart () {
            pieChart.frame = CGRect(x: 29, y: 50, width: 335, height: 350)
            pieChart.holeRadiusPercent = 0.3
            pieChart.transparentCircleRadiusPercent = 0
            pieChart.legend.enabled = false
            pieChart.spin(duration: 1.6, fromAngle: 0, toAngle: 360)
        }
        
        /// если нет нормы ккал, то предлагается добавить
        func getTextOfTitleOfChart () {
            if countNormalCalories() == 0 {
                pieChart.centerText = "Добавить"
            }
            else {
                pieChart.centerText = "\(countCaloriesOfUserMeal())/\(countNormalCalories())"
            }
        }
    }
    
    /// считает ккал приёма пищи
    func countCaloriesOfMeal (_ meal: Meal) -> Double {
        var result : Double = 0
        
        guard let products = meal.eatenProducts, products.count != 0 else { return 0 }
        
        for product in products {
            result += product.calories
        }
        
        return result
    }
    
    private func countCaloriesOfUserMeal () -> Int {
        var caloriesEaten = 0
        for meal in userMeals {
            caloriesEaten += Int(countCaloriesOfMeal(meal))
        }
        return caloriesEaten
    }
    
    /// считает норму ккал
    private func countNormalCalories () -> Int {
        if sex == "Женщина" {
            let a = Int(9.563 * Double(weight))
            let b = Int(1.85 * Double(height))
            let c = Int(4.676 * Double(age))
            
            let result = Int(Int(655.1) + a + b - c)
            return result + countStyleOfLife()
        }
        else if sex == "Мужчина" {
            let a = Int(13.75 * Double(weight))
            let b = Int(5.003 * Double(height))
            let c = Int(6.775 * Double(age))
            
            let result = Int(Int(66.5) + a + b - c)
            return result + countStyleOfLife()
        }
        else {
            return 0
        }
    }
    
    /// даёт значения целям для высчитывания нормы ккал
    private func countStyleOfLife () -> Int {
        switch aim {
        case "Скинуть вес":
            return 0
        case "Набрать вес":
            return 444
        case "Подсушиться":
            return -200
        default:
            return 0
        }
    }
}

