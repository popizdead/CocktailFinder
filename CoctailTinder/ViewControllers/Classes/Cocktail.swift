//
//  Cocktail.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 10/03/2021.
//

import Foundation
import UIKit
import Alamofire

class Coctail {
    var name : String
    var category : String
    var id : String
    var imageURL : String
    var glass : String
    var ingrArray : [Ingredient]
    var instruction : String
    var image: UIImage?
    
    init(name: String, category: String, id: String, imgUrl: String, glass: String, ingrArray: [Ingredient], instr: String) {
        self.name = name
        self.category = category
        self.id = id
        self.imageURL = imgUrl
        self.glass = glass
        self.ingrArray = ingrArray
        self.instruction = instr
    }
    
    func getCocktailImage() {
        AF.request(self.imageURL).response { (data) in
            if let dataImg = data.data {
                let cocktailImage = UIImage(data: dataImg)
                self.image = cocktailImage
                self.updateController()
            }
        }
    }
    
    func getIngredientImage() {
        for ingr in self.ingrArray {
            AF.request("https://www.thecocktaildb.com/images/ingredients/\(ingr.name.makeUrlable()).png").responseData { (response) in
                if let data = response.data {
                    if let img = UIImage(data: data) {
                        ingr.ingrImage = img
                        self.updateController()
                    }
                }
            }
        }
    }
    
    func updateController() {
        if requestedFrom == .swipe {
            NotificationCenter.default.post(name: NSNotification.Name("updateCard"), object: nil)
        }
        else if requestedFrom == .favourite {
            NotificationCenter.default.post(name: Notification.Name("updateFavCV"), object: nil)
        }
    }
}

struct ShortCocktail {
    var name : String
    var id: String
}
