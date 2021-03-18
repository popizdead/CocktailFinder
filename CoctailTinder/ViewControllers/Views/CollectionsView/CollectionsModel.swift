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
var responseArray : [ShortCocktail] = []

enum typeRequest {
    case new
    case pop
    case nonAlc
    case cocktails
    case shake
    case shot
    case coffee
    case beer
    case punch
    case random
}

func createShort(dict: [String:Any]) -> ShortCocktail? {
    if let name = dict["strDrink"] as? String {
        if let id = dict["idDrink"] as? String {
            return ShortCocktail(name: name, id: id)
        }
    }
    return nil
}

func collectionRequest(type: typeRequest) {
    requestedFrom = .collection
    
    sourceItemsArray.removeAll()
    responseArray.removeAll()
    
    switch type {
    case .new:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/latest.php")
    case .pop:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/popular.php")
    case .nonAlc:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?a=Non_Alcoholic")
    case .cocktails:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail")
    case .shake:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail")
    case .shot:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Shot")
    case .coffee:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail")
    case .beer:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Beer")
    case .punch:
        idCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail")
    case .random:
        fullCocktailArrayRequest(url: "https://www.thecocktaildb.com/api/json/v2/9973533/randomselection.php")
    }
    
}

func fullCocktailArrayRequest(url: String) {
    AF.request(url).responseJSON { (data) in
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

func idCocktailArrayRequest(url: String) {
    AF.request(url).responseJSON { (data) in
        guard let allDataDict = data.value as? [String : Any] else { return }
        if let cocktailsArray = allDataDict["drinks"] as? [[String:Any]] {
            for object in cocktailsArray {
                if let short = createShort(dict: object) {
                    responseArray.append(short)
                }
            }
            showResponseFromArray()
        }
    }
}

func showResponseFromArray() {
    for index in Range(0...10) {
        let object = responseArray[index]
        getCocktailByID(id: object.id)
    }
}
