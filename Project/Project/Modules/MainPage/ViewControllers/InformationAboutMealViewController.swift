//
//  InformationAboutMealViewController.swift
//  Project
//
//  Created by Mac on 2023-07-08.
//

import UIKit

/// сколько и чего вы съели, модальный экран
final class InformationAboutMealViewController : BaseViewController {
    
    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    @IBOutlet weak var eatenCalloriesLabel: UILabel!
    @IBOutlet weak var numberOfEatenCalloriesLabel: UILabel!
    @IBOutlet weak var eatenProductsTableView: UITableView!
    
    private var dataWithProducts : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eatenProductsTableView.dataSource = self
        eatenProductsTableView.delegate = self
    }
    
    /// дата задаётся из diaryViewController
    func setUpInformationAboutMeal(meal: Meal) {
        let diaryViewController = DiaryViewController()
        titleNavigationBar.topItem?.title = meal.name
        numberOfEatenCalloriesLabel.text = String(diaryViewController.countCaloriesOfMeal(meal))
        dataWithProducts = meal.eatenProducts ?? []
    }
}

/// всё, что связано с табличкой
extension InformationAboutMealViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataWithProducts.count
    }
    /// возвращает ячейку InformationAboutMealTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = eatenProductsTableView.dequeueReusableCell(withIdentifier: "InformationAboutMealTableViewCell") as? InformationAboutMealTableViewCell else { return UITableViewCell() }
        
        let product = dataWithProducts[indexPath.row]
        
        cell.setUpForMealTable(product)
        
        return cell
    }
}
