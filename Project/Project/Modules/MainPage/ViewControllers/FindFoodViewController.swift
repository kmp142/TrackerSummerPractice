//
//  FindFoodViewController.swift
//  Project
//
//  Created by Mac on 2023-07-06.
//

import UIKit

/// ищет продукты в списке, есть сохранение этих продуктов через UserDefaults
final class FindFoodViewController : UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var productsSearchBar: UISearchBar!
    @IBOutlet weak var findProdactTableView: UITableView!
    @IBOutlet weak var mealNameNavigationBar: UINavigationBar!
    
    @IBAction func addNewProductButton(_ sender: Any) {
    }
    
    private var isSearching = false
    private var filteredSearchedData: [Product] = []
    
    /// сохраняет продукт через UserDefaults
    private var dataWithProducts: [Product]{
        
        get {
            if let data = defaults.value(forKey: "products") as? Data {
                return try! PropertyListDecoder().decode([Product].self, from: data)
            } else { return [Product]() }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "products")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // если приложение запущено не 1 раз и в листе с данными уже что-то есть, не нужно ничего делать и обратно
        let containsElement = dataWithProducts.contains { product in
            return dataWithProductsExample.contains { $0 == product }
        }
        if !containsElement {
            add()
        }
        
        // скрытие полосы UINavigationBar
        UINavigationBar.appearance().shadowImage = UIImage()
        
        findProdactTableView.dataSource = self
        findProdactTableView.delegate = self
        productsSearchBar.delegate = self
    }
    
    func setInfoForFindFoodViewController (title: String) {
        mealNameNavigationBar.topItem?.title = title
    }
    
    /// сохраняет продукт через UserDefaults
    func saveProduct(name: String, calories: Double, fats: Double, proteins: Double, carbohydrates: Double, other: [String: Double]?) {
        let product = Product(name: name, calories: calories, fats: fats, proteins: proteins, carbohydrates: carbohydrates, other: other)
        dataWithProducts.append(product)
    }
    
    /// добавляет 1 массив к другому + сохранение в UserDefaults
    private func add () {
        dataWithProducts += dataWithProductsExample
        
        if let data = try? PropertyListEncoder().encode(dataWithProducts) {
            defaults.set(data, forKey: "products")
        }
    }
    
    private var dataWithProductsExample: [Product] = [
        Product(name: "Яблоко", calories: 47, fats: 0.4, proteins: 0.4, carbohydrates: 9.8, other: ["Содержание воды" : 89]),
        Product(name: "Яйцо куриное", calories: 157, fats: 11.5, proteins: 12.7, carbohydrates: 0.7, other: ["Содержание воды": 74]),
        Product(name: "Куриная грудка", calories: 113, fats: 1.9, proteins: 23.6, carbohydrates: 0.4, other: nil),
        Product(name: "Гречневая крупа", calories: 308, fats: 3.3, proteins: 12.6, carbohydrates: 57.1, other: nil),
        Product(name: "Молоко", calories: 60, fats: 3.2, proteins: 2.9, carbohydrates: 4.7, other: nil),
        Product(name: "Биг хит из 'Вкусно и точка'", calories: 522, fats: 27, proteins: 27, carbohydrates: 42, other: nil)
    ]
}

/// поиск элементов в SearchBar
extension FindFoodViewController : UISearchBarDelegate {
    
    /// поиск элемента в таблице с учётом регистра
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSearchedData.removeAll()
        
        guard searchText != "" || searchText != " " else { return }
        
        for item in dataWithProducts {
            let text = searchText.lowercased()
            let isArrayContain = item.name.lowercased().range(of: text)
                    
            if isArrayContain != nil { filteredSearchedData.append(item) }
        }
        
        if searchBar.text == "" {
            isSearching = false
            findProdactTableView.reloadData()
        }
        else {
            isSearching = true
            filteredSearchedData = filteredSearchedData.filter({$0.name.lowercased().contains(searchBar.text?.lowercased() ?? "")})
            findProdactTableView.reloadData()
        }
    }
}

/// всё, что связано с таблицей поиска
extension FindFoodViewController : UITableViewDataSource, UITableViewDelegate {
    
    /// если идёт поиск возвращается кол-во ячеек, подходящих под него, иначе - все данные
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredSearchedData.count }
        else { return dataWithProducts.count }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    /// если идёт поиск возвращается ячейка из одного массива, иначе - из другого
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = findProdactTableView.dequeueReusableCell(withIdentifier: "FindProductTableViewCell") as? FindProductTableViewCell else { return UITableViewCell() }

        if isSearching { cell.textLabel?.text = filteredSearchedData[indexPath.row].name }
        else { cell.textLabel?.text = dataWithProducts[indexPath.row].name }
        
        return cell
    }
    
    /// при нажатии на элемент, пушится АddFoodViewController с данными из ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = dataWithProducts[indexPath.row]

        guard let addFoodViewController = storyboard?.instantiateViewController(withIdentifier: "AddFoodViewController") as? AddFoodViewController else { return }
        
        let meal = mealNameNavigationBar.topItem?.title
        addFoodViewController.loadViewIfNeeded()
        
        // установка делегата addFoodViewController в diaryViewController
        if let diaryViewController = navigationController?.viewControllers.first(where: { $0 is DiaryViewController }) as? DiaryViewController {
            addFoodViewController.delegate = diaryViewController
        } else { return }
        
        addFoodViewController.setInfoForAddFoodViewController(meal: meal ?? "Meal", product: product)
        
        navigationController?.pushViewController(addFoodViewController, animated: true)
    }
}

/// всё, что связано с делегатом для передачи данных из AddNewProductViewController
extension FindFoodViewController : FindFoodViewControllerDelegate {
    
    /// подписка на делегат
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let destination = segue.destination as? AddNewProductViewController else { return }
        destination.delegate = self
    }
    
    ///функция обновления даты, при добавлении нового продукта
    func update(newProduct: Product) {
        dataWithProducts.append(newProduct)
        findProdactTableView.reloadData()
    }
}
