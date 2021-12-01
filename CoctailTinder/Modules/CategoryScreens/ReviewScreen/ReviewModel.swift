//
//  CollectionsModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import Foundation
import UIKit

public enum UIStateType {
    case ingr
    case categories
}

//MARK: -SEGUE {
extension ReviewCategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCocktail = selectedCocktail else { return }
        if segue.identifier == "collectionToReview" {
            if let vc = segue.destination as? CocktailViewController {
                vc.reviewCocktail = selectedCocktail
            }
        }
    }
}


//MARK: -REVIEW SCREEN
extension ReviewCategoryViewController {
    func sourceUpdate() {
        self.categoryCocktailSource.removeAll()
        
        switch requestFrom {
        case .ingr:
            guard let ingr = requestedIngredient else { return }
            
            network.byIngredientSearch(ingr.name) { [weak self] cocktail in
                self?.apply(cocktail)
            }
        case .categories:
            guard let category = requestedCategory else { return }
            
            network.categoryRequest(category.getUrl(), category.getRequestType()) { [weak self] cocktail in
                self?.apply(cocktail)
            }
        }
    }
    
    private func apply(_ cocktail: Cocktail?) {
        guard let cocktail = cocktail else { return }
        cocktail.getImages {
            self.update()
        }
        
        self.categoryCocktailSource.append(cocktail)
    }
}


