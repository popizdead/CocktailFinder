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
        newsCocktailRequest()
    case .pop:
        popCocktailRequest()
    case .nonAlc:
        nonAlcRequest()
    case .cocktails:
        topCocktailsRequest()
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

func nonAlcRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?a=Non_Alcoholic").responseJSON { (data) in
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

func topCocktailsRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?c=Cocktail").responseJSON { (data) in
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
