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
    let name : String
    var ingrImage : UIImage?
    var measure : String?
    
    var isDownloading: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    func getImage(_ action: @escaping () -> Void) {
        isDownloading = true
        AF.request("https://www.thecocktaildb.com/images/ingredients/\(self.name.makeUrlable()).png").responseData { (response) in
            if let data = response.data {
                if let img = UIImage(data: data) {
                    self.ingrImage = img
                    self.isDownloading = false
                    
                    action()
                }
            }
        }
    }
}

