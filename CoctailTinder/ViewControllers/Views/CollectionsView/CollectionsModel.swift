//
//  CollectionsModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 17/03/2021.
//

import Foundation
import UIKit
import Alamofire

var sourceItemsArray : [Coctail] = []

enum typeRequest {
    case new
    case pop
}

func collectionRequest(type: typeRequest) {
    requestedFrom = .collection
    sourceItemsArray.removeAll()
    
    switch type {
    case .new:
        newsCocktailRequest()
    case .pop:
        popCocktailRequest()
    }
}

func newsCocktailRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/latest.php").responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let cocktail = createCoctail(from: object) {
                    cocktail.getCocktailImage()
                    cocktail.getIngredientImage()
                    sourceItemsArray.append(cocktail)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
        }
    }
}

func popCocktailRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/popular.php").responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let cocktail = createCoctail(from: object) {
                    cocktail.getCocktailImage()
                    cocktail.getIngredientImage()
                    sourceItemsArray.append(cocktail)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
        }
    }
}
