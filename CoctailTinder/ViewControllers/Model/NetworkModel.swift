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

//func createCoctail(from dict: [String : Any]) -> Cocktail? {
//    let coctailData = dict
//    if let name = coctailData["strDrink"] as? String {
//        if let instrPrep = coctailData["strInstructions"] as? String {
//            let instr = instrPrep.capitalizingFirstLetter()
//            if let category = coctailData["strCategory"] as? String {
//                if let id = coctailData["idDrink"] as? String {
//                    if let glass = coctailData["strGlass"] as? String {
//                        if let imgUrl = coctailData["strDrinkThumb"] as? String {
//                            let ingredientArray = createIngredients(from: coctailData)
//                            if ingredientArray.count > 0 {
//                                let cocktailObject = Cocktail(name: name, category: category, id: id, imgUrl: imgUrl, glass: glass, ingrArray: ingredientArray, instr: instr)
//                                return cocktailObject
//                            } else {
//                                return nil
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    return nil
//}
//
//func createIngredients(from dict: [String:Any]) -> [Ingredient] {
//    var ingrArray : [Ingredient] = []
//
//    for index in Range(1...15) {
//        if let name = dict["strIngredient\(index)"] as? String {
//            if let measure = dict["strMeasure\(index)"] as? String {
//                if name != "" {
//                    let ingr = Ingredient(name: name)
//                    ingr.measure = measure
//                    ingrArray.append(ingr)
//                } else {
//                    break
//                }
//
//            }
//        } else {
//            break
//        }
//    }
//
//    return ingrArray
//}
//
