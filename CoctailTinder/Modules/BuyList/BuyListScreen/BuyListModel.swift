//
//  BuyListModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 24/11/2021.
//

import Foundation

extension BuyListViewController {
    enum VCState {
        case all
        case searching
    }
    
    func allIngredientsRequest() {
        network.getAllIngredientsList { ingredient in
            self.ingredientsSource.append(ingredient)
            self.UIUpdate()
        }
    }
    
    func search(_ text: String?) {
        searchSource.removeAll()
        guard let text = text else {
            return
        }

        ingredientsSource.forEach({
            let contains = $0.name.lowercased() == text.lowercased()
            if contains {
                searchSource.append($0)
            }
        })
        
        UIUpdate()
    }
}
