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


//MARK: -CATEGORY SCREEN
extension CategoryViewController {
    func getSource() {
        getListIngredients()
        getCategories()
        
        UIUpdate()
    }
    
    private func getListIngredients() {
        network.getIngredientCategory { category in
            self.ingredientSource.append(category)
            self.sort()
        }
    }
    
    private func getCategories() {
        self.categoriesSource = dataService.getCategoryList()
    }
    
    private func sort() {
        self.ingredientSource.sort(by: {
            $0.count > $1.count
        })
    }
}

extension CategoryViewController {
    enum SourceStateType {
        case search
        case all
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemsList" {
            let vc = segue.destination as! ReviewCategoryViewController
            
            vc.requestFrom = self.UIState
        }
    }
    
    func search(_ text: String) {
        switch UIState {
        case .ingr:
            ingredientSearch.removeAll()
            
            ingredientSource.forEach({
                let contains = $0.name.lowercased().contains(text.lowercased())
                if contains {
                    ingredientSearch.append($0)
                }
            })
            
        case .categories:
            categoriesSearch.removeAll()
            
            categoriesSource.forEach({
                let contains = $0.getTitle().lowercased().contains(text.lowercased())
                if contains {
                    categoriesSearch.append($0)
                }
            })
        }
        
        UIUpdate()
    }
}

//MARK: -REVIEW SCREEN
extension ReviewCategoryViewController {
    func sourceUpdate() {
        self.collectionCocktailSource.removeAll()
        
        switch requestFrom {
        case .ingr:
            let ingr = dataService.ingrCategoryReview
            
            network.byIngredientSearch(ingr.name) { cocktail in
                self.apply(cocktail)
            }
        case .categories:
            let category = dataService.categoryReview
            
            network.categoryRequest(category.getUrl(), category.getRequestType()) { cocktail in
                self.apply(cocktail)
            }
        }
    }
    
    private func apply(_ cocktail: Cocktail?) {
        guard let cocktail = cocktail else { return }
        cocktail.getImages {
            self.update()
        }
        
        self.collectionCocktailSource.append(cocktail)
    }
}


