//
//  NetworkModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import Alamofire

enum dataRequestedFrom {
    case swipe
    case favourite
    case collection
}

var requestedFrom = dataRequestedFrom.swipe

var indexCurrentCocktail = 0
var isFilterChanged = true

func requestCocktail() {
    if currentRequest.ingr == .all && currentRequest.alc == .all {
        //Random
        randomCoctailRequest()
    }
}

func randomCoctailRequest() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/random.php").responseJSON { (data) in
        guard let dataDict = data.value as? [String : Any] else { return }
        if let arrayData = dataDict["drinks"] as? [[String:Any]] {
            if let cocktailData = arrayData.first {
                if let coctail = createCoctail(from: cocktailData) {
                    currentCoctail = coctail
                    currentCoctail.getIngredientImage()
                    currentCoctail.getCocktailImage()
                    NotificationCenter.default.post(name: NSNotification.Name("openCard"), object: nil)
                }
            }
        }
    }
}

func getCocktailByID(id: String) {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
        guard let dataDict = data.value as? [String : Any] else { return }
        if let arrayData = dataDict["drinks"] as? [[String:Any]] {
            if let cocktailData = arrayData.first {
                if let cocktail = createCoctail(from: cocktailData) {
                    if requestedFrom == .favourite {
                        cocktail.getCocktailImage()
                        cocktail.getIngredientImage()
                        favArray.append(cocktail)
                        NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
                    }
                    else if requestedFrom == .collection {
                        cocktail.getIngredientImage()
                        cocktail.getCocktailImage()
                        sourceItemsArray.append(cocktail)
                        NotificationCenter.default.post(name: NSNotification.Name("updateItemsCV"), object: nil)
                    }
                    
                }
            }
        }
    }
}

func createCoctail(from dict: [String : Any]) -> Coctail? {
    let coctailData = dict
    if let name = coctailData["strDrink"] as? String {
        if let instrPrep = coctailData["strInstructions"] as? String {
            let instr = instrPrep.capitalizingFirstLetter()
            if let category = coctailData["strCategory"] as? String {
                if let id = coctailData["idDrink"] as? String {
                    if let glass = coctailData["strGlass"] as? String {
                        if let imgUrl = coctailData["strDrinkThumb"] as? String {
                            let ingredientArray = createIngredients(from: coctailData)
                            let cocktailObject = Coctail(name: name, category: category, id: id, imgUrl: imgUrl, glass: glass, ingrArray: ingredientArray, instr: instr)
                            return cocktailObject
                        }
                    }
                }
            }
        }
    }
    return nil
}

func createIngredients(from dict: [String:Any]) -> [Ingredient] {
    var ingrArray : [Ingredient] = []
    
    for index in Range(1...15) {
        if let name = dict["strIngredient\(index)"] as? String {
            if let measure = dict["strMeasure\(index)"] as? String {
                let ingr = Ingredient(name: name)
                ingrArray.append(ingr)
            }
        } else {
            break
        }
    }
    
    return ingrArray
}

