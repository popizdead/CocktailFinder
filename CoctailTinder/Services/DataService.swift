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
    var reviewCocktail: Cocktail?
    
    //User source
    var userBuyList : [Ingredient] = []
    var favArray : [Cocktail] = []
    
    //Categories
    var categoryReview : CategoryType = .cocoa
    var ingrCategoryReview : Ingredient = Ingredient(name: "")
    
    let network = NetworkService.shared
    
    //MARK: -COCKTAIL
    func isFavoriteCocktail(_ cocktail: Cocktail) -> Bool {
        return self.favArray.contains(where: {
            $0.id == cocktail.id
        })
    }
    
    //MARK: -INGREDIENT
    public enum IngredientAction {
        case add
        case remove
    }
    
    func buyListAction(_ ingr: Ingredient, _ action: IngredientAction) {
        switch action {
        case .add:
            self.userBuyList.append(ingr)
            self.saveBuyListItem(ingr: ingr)
        case .remove:
            self.userBuyList = self.userBuyList.filter({$0.name != ingr.name})
            self.deleteBuyListItem(name: ingr.name)
        }
    }
    
    //MARK: -CATEGORIES
    func getCategoryList() -> [CategoryType] {
        let array : [CategoryType] = [
            .new, .pop, .nonAlc, .cocktails, .shake, .shot, .coffee, .beer, .punch, .random, .soda, .others, .homemade, .ordinary, .cocoa
        ]
        
        return array
    }
    
}
