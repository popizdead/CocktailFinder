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

