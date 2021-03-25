//
//  SearchModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 18/03/2021.
//

import Foundation
import Alamofire

var resultSearchArray : [Coctail] = []

func searchItems(text: String) {
    requestedFrom = .search
    resultSearchArray.removeAll()
    AF.request("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(text)").responseJSON { (response) in
        guard let data = response.value as? [String:Any] else { return }
        if let allDrinks = data["drinks"] as? [[String:Any]] {
            for object in allDrinks {
                if let cocktail = createCoctail(from: object) {
                    cocktail.getCocktailImage()
                    cocktail.getIngredientImage()
                    resultSearchArray.append(cocktail)
                }
                NotificationCenter.default.post(name: NSNotification.Name("updateSearchResult"), object: nil)
            }
            
        }
    }
}
