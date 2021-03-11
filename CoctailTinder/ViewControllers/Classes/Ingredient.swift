//
//  Ingredient.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import Foundation
import UIKit
import Alamofire

struct IngredientShort {
    var name = String()
    var measure = String()
}

var ingredientDict : [String : UIImage] = [:]

class Ingredient {
    var name : String
    var ingrImage : UIImage?
    var measure : String?
    
    init(name: String) {
        self.name = name
    }
}

/*
func getAllIngredients() {
    AF.request("https://www.thecocktaildb.com/api/json/v2/9973533/list.php?i=list").responseJSON { (response) in
        if let dataArray = response.value as? [String : Any] {
            if let ingrDict = dataArray["drinks"] as? [[String:Any]] {
                for ingr in ingrDict {
                    if let name = ingr["strIngredient1"] as? String {
                        getIngredientImage(toName: name)
                    }
                }
                print(ingrDict.count)
            }
        }
    }
}
*/

