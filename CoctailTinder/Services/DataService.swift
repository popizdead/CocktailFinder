//
//  DataService.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 24/11/2021.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    var alertIngredient = Ingredient(name: "")
    
    //User source
    var userBuyList : [Ingredient] = []
    var favArray : [Cocktail] = []
    
    var collectionCocktailSource : [Cocktail] = []
    
    //Object states
    func isFavorite(_ cocktail: Cocktail) -> Bool {
        return self.favArray.contains(where: {
            $0.id == cocktail.id
        })
    }
}
