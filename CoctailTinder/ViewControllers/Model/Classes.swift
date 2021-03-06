//
//  Classes.swift
//  CoctailTinder
//
//  Created by Даниил Дорожкин on 05/03/2021.
//

import Foundation
import UIKit

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
}

struct Ingredient {
    var name = String()
    var measure = String()
}
