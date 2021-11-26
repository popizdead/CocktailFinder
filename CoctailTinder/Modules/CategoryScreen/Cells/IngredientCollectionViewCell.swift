//
//  IngredientCollectionViewCell.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 26/11/2021.
//

import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ingredientNameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var ingredient: CategoryIngredient?
    
    func setup() {
        guard let ingredient = ingredient else {
            return
        }
        
        ingredientNameLbl.text = ingredient.name
        countLbl.text = "\(ingredient.count)"
    }
}
