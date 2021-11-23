//
//  NetworkModel.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import Alamofire


//var requestedFrom = dataRequestedFrom.favorite
var screenName = String()
var savedCocktailsGetting = false



func getCoreCocktailByID(id: String) {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=\(id)").responseJSON { (data) in
        guard let dataDict = data.value as? [String : Any] else { return }
        if let arrayData = dataDict["drinks"] as? [[String:Any]] {
            if let cocktailData = arrayData.first {
                if let cocktail = createCoctail(from: cocktailData) {
                    cocktail.getCocktailImage()
                    cocktail.getIngredientImage()
                    favArray.append(cocktail)
                    NotificationCenter.default.post(name: NSNotification.Name("updateFavCV"), object: nil)
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
                            if ingredientArray.count > 0 {
                                let cocktailObject = Coctail(name: name, category: category, id: id, imgUrl: imgUrl, glass: glass, ingrArray: ingredientArray, instr: instr)
                                return cocktailObject
                            } else {
                                return nil
                            }
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
                if name != "" {
                    let ingr = Ingredient(name: name)
                    ingr.measure = measure
                    ingrArray.append(ingr)
                } else {
                    break
                }

            }
        } else {
            break
        }
    }

    return ingrArray
}

