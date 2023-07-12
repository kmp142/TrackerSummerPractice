//
//  MealsTableViewCell.swift
//  Project
//
//  Created by Mac on 2023-07-06.
//

import UIKit

final class MealsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameOfMealTitleLabel : UILabel!
    @IBOutlet weak var imageOfMealImageView : UIImageView!
    @IBOutlet weak var addFoodButton : UIButton!
    weak var navigationController: UINavigationController?
    weak var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// кнопка в ячейке, которая осуществляет переход на FindFoodViewController
    @IBAction func addFoodButtonDidTap(_ sender: UIButton) {
        let tag = sender.tag
        var meal : String
        
        switch tag {
        case 0:
            meal = "Завтрак"
        case 1:
            meal = "Обед"
        case 2:
            meal = "Ужин"
        case 3:
            meal = "Перекус"
        default:
            meal = "Завтрак"
        }

        guard let findFoodViewController = viewController?.storyboard?.instantiateViewController(withIdentifier: "FindFoodViewController") as? FindFoodViewController else { return }
        
        findFoodViewController.loadViewIfNeeded()
        findFoodViewController.setInfoForFindFoodViewController(title: meal)
        
        navigationController?.pushViewController(findFoodViewController, animated: true)
    }
    
    func setUpForMealsTable (_ meal: Meal) {
        var image: UIImage
        switch meal.name {
        case "Завтрак":
            image = UIImage(named: "breakfast") ?? .actions
        case "Обед":
            image = UIImage(named: "obed") ?? .actions
        case "Ужин":
            image = UIImage(named: "dinner") ?? .actions
        case "Перекус":
            image = UIImage(named: "launch") ?? .actions
        default:
            image = .actions
        }
        
        nameOfMealTitleLabel.text = meal.name
        imageOfMealImageView.image = image
    }
}
