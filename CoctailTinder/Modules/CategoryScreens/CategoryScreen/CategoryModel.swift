//
//  CategoryModel.swift
//  CoctailFinder
//
//  Created by Даниил Дорожкин on 01/12/2021.
//

import Foundation
import UIKit

//MARK: -SOURCE
struct CategorySource {
    var categoriesSource : [CategoryType] = []
    var categoriesSearch : [CategoryType] = []
    
    var ingredientSource : [CategoryIngredient] = []
    var ingredientSearch : [CategoryIngredient] = []
}

//MARK: -CATEGORY SCREEN
extension CategoryViewController {
    func getSource() {
        getListIngredients()
        getCategories()
        
        UIUpdate()
    }
    
    private func getListIngredients() {
        network.getIngredientCategory { [weak self] category in
            self?.source.ingredientSource.append(category)
            self?.sort()
        }
    }
    
    private func getCategories() {
        self.source.categoriesSource = dataService.getCategoryList()
    }
    
    private func sort() {
        self.source.ingredientSource.sort(by: {
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
            source.ingredientSearch.removeAll()
            
            source.ingredientSource.forEach({
                let contains = $0.name.lowercased().contains(text.lowercased())
                if contains {
                    source.ingredientSearch.append($0)
                }
            })
            
        case .categories:
            source.categoriesSearch.removeAll()
            
            source.categoriesSource.forEach({
                let contains = $0.getTitle().lowercased().contains(text.lowercased())
                if contains {
                    source.categoriesSearch.append($0)
                }
            })
        }
        
        UIUpdate()
    }
}
