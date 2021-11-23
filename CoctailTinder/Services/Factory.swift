//
//  Factory.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 23/11/2021.
//

import Foundation

class Factory {
    static let shared = Factory()
    
    func createCoctail(from dict: [String : Any]) -> Coctail? {
        let cocktailData = dict
        if let name = cocktailData["strDrink"] as? String {
            if let instrPrep = cocktailData["strInstructions"] as? String {
                let instr = instrPrep.capitalizingFirstLetter()
                if let category = cocktailData["strCategory"] as? String {
                    if let id = cocktailData["idDrink"] as? String {
                        if let glass = cocktailData["strGlass"] as? String {
                            if let imgUrl = cocktailData["strDrinkThumb"] as? String {
                                
                                let ingredientArray = createIngredients(from: cocktailData)
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
    
    private func createIngredients(from dict: [String:Any]) -> [Ingredient] {
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

}
